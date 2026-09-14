terraform {
  required_version = ">= 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
  rendered_policy_contents = {
    for policy_key, policy in var.service_control_policies :
    policy_key => replace(
      replace(
        replace(
          replace(
            file("${path.module}/policies/${policy.policy_file}"),
            "\"__ALLOWED_REGION__\"",
            lookup(policy.substitutions, "{{allowed_region}}", "\"__ALLOWED_REGION__\"")
          ),
          "\"__ALLOWED_REGIONS__\"",
          lookup(policy.substitutions, "{{allowed_regions}}", "\"__ALLOWED_REGIONS__\"")
        ),
        "\"__NETWORK_ALLOWED_ACTIONS__\"",
        lookup(policy.substitutions, "{{network_allowed_actions}}", "\"__NETWORK_ALLOWED_ACTIONS__\"")
      ),
      "\"__ALLOWED_ACTIONS__\"",
      lookup(policy.substitutions, "{{allowed_actions}}", "\"__ALLOWED_ACTIONS__\"")
    )
  }

  ou_policy_attachments = merge(
    {},
    [
      for policy_key, policy in var.service_control_policies : {
        for ou_name in try(policy.target_ous, []) :
        "${policy_key}:ou:${ou_name}" => {
          policy_key  = policy_key
          target_id   = var.ou_ids[ou_name]
          target_kind = "ou"
          target_key  = ou_name
        }
        if contains(keys(var.ou_ids), ou_name)
      }
    ]...
  )

  account_policy_attachments = merge(
    {},
    [
      for policy_key, policy in var.service_control_policies : {
        for account_key in try(policy.target_accounts, []) :
        "${policy_key}:account:${account_key}" => {
          policy_key  = policy_key
          target_id   = var.account_ids[account_key]
          target_kind = "account"
          target_key  = account_key
        }
        if contains(keys(var.account_ids), account_key)
      }
    ]...
  )

  policy_attachments = merge(local.ou_policy_attachments, local.account_policy_attachments)

  existing_attachment_lookup_targets = local.ou_policy_attachments
}

data "aws_organizations_policies" "service_control_policies" {
  filter = "SERVICE_CONTROL_POLICY"
}

data "aws_organizations_policy" "existing" {
  for_each = toset(data.aws_organizations_policies.service_control_policies.ids)

  policy_id = each.value
}

data "aws_organizations_policies_for_target" "existing" {
  for_each = local.existing_attachment_lookup_targets

  target_id = each.value.target_id
  filter    = "SERVICE_CONTROL_POLICY"
}

locals {
  existing_policy_ids_by_key = {
    for policy_key, policy in var.service_control_policies :
    policy_key => [
      for existing_policy in values(data.aws_organizations_policy.existing) :
      existing_policy.id
      if existing_policy.name == policy.name
    ][0]
    if length([
      for existing_policy in values(data.aws_organizations_policy.existing) :
      existing_policy.id
      if existing_policy.name == policy.name
    ]) > 0
  }

  existing_policy_attachment_keys = toset([
    for attachment_key, attachment in local.policy_attachments :
    attachment_key
    if contains(keys(local.existing_policy_ids_by_key), attachment.policy_key)
    && contains(
      try(data.aws_organizations_policies_for_target.existing[attachment_key].ids, []),
      local.existing_policy_ids_by_key[attachment.policy_key]
    )
  ])

  managed_policy_attachments = {
    for attachment_key, attachment in local.policy_attachments :
    attachment_key => attachment
    if !contains(local.existing_policy_attachment_keys, attachment_key)
  }

  policy_ids = merge(
    local.existing_policy_ids_by_key,
    {
      for policy_key, policy in aws_organizations_policy.this :
      policy_key => policy.id
    }
  )
}

resource "aws_organizations_policy" "this" {
  for_each = var.service_control_policies

  name        = each.value.name
  description = each.value.description
  content     = local.rendered_policy_contents[each.key]
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "this" {
  for_each = local.managed_policy_attachments

  policy_id = local.policy_ids[each.value.policy_key]
  target_id = each.value.target_id
}
