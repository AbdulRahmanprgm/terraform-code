output "ou_ids" {
  description = "Map of organizational unit names to OU IDs."
  value       = module.organizational_units.ou_ids
}

output "account_ids" {
  description = "Map of landing-zone account keys to the AWS account IDs created by this configuration."
  value       = module.accounts.account_ids
}

output "scp_policy_ids" {
  description = "Map of active service control policy keys to AWS Organizations policy IDs."
  value       = module.scp.scp_policy_ids
}

output "debug_rendered_scp_policies" {
  description = "Rendered SCP JSON keyed by policy key for debugging policy substitutions."
  value       = module.scp.rendered_policy_contents
}

output "debug_scp_attachments" {
  description = "Active SCP attachments keyed by attachment key for debugging."
  value       = module.scp.policy_attachments
}

output "debug_effective_allowed_actions" {
  description = "Allowed action lists keyed by account type for debugging SCP boundaries."
  value = {
    network         = local.network_allowed_actions
    log_archive     = local.log_archive_allowed_actions
    audit           = local.audit_allowed_actions
    backup          = local.backup_allowed_actions
    shared_services = local.shared_services_allowed_actions
    development     = local.development_allowed_actions
    test            = local.test_allowed_actions
    production      = local.production_allowed_actions
    sandbox         = local.sandbox_allowed_actions
  }
}

output "create_organization_flag" {
  description = "Echo of the create_organization variable for visibility and to ensure the variable is used."
  value       = var.create_organization
}
