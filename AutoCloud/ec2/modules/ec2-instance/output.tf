output "instance_id" {
  value = local.instance_id
}

output "public_ip" {
  description = "Public IP of the instance."
  value       = local.public_ip
}

output "elastic_ip" {
  description = "Elastic IP address (non-empty only when use_elastic_ip=true)"
  value       = local.elastic_ip
}

output "private_ip" {
  value = local.private_ip
}

output "security_group_ids" {
  description = "Security group IDs attached to the instance"
  value       = local.instance_security_group_ids
}
