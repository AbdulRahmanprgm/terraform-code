data "aws_organizations_policies" "service_control_policies_import" {
  filter = "SERVICE_CONTROL_POLICY"
}

data "aws_organizations_policy" "service_control_policy_import" {
  for_each = toset(data.aws_organizations_policies.service_control_policies_import.ids)

  policy_id = each.value
}

locals {
  existing_scp_imports = {
    for policy_key, policy in local.active_service_control_policies :
    policy_key => [
      for existing_policy in values(data.aws_organizations_policy.service_control_policy_import) :
      existing_policy.id
      if existing_policy.name == policy.name
    ][0]
    if length([
      for existing_policy in values(data.aws_organizations_policy.service_control_policy_import) :
      existing_policy.id
      if existing_policy.name == policy.name
    ]) > 0
  }
}

import {
  for_each = local.existing_scp_imports
  to       = module.scp.aws_organizations_policy.this[each.key]
  id       = each.value
}
