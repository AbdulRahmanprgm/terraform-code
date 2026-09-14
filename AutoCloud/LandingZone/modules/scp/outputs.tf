output "scp_policy_ids" {
  description = "Map of service control policy keys to AWS Organizations policy IDs."
  value       = local.policy_ids
}

output "rendered_policy_contents" {
  description = "Rendered SCP JSON content keyed by policy key."
  value       = local.rendered_policy_contents
}

output "policy_attachments" {
  description = "Planned SCP attachments keyed by attachment key."
  value       = local.policy_attachments
}
