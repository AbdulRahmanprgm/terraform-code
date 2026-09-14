output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP address, or null for private-only instances."
  value       = module.ec2_instance.public_ip
}

output "elastic_ip" {
  description = "Elastic IP address (non-empty only when use_elastic_ip=true)"
  value       = module.ec2_instance.elastic_ip
}

output "private_ip" {
  value = module.ec2_instance.private_ip
}

output "vpc_id" {
  description = "VPC ID used by the instance."
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "Subnet ID used by the instance."
  value       = module.network.subnet_id
}

output "security_group_ids" {
  description = "Security group IDs attached to the instance."
  value       = module.ec2_instance.security_group_ids
}

output "key_pair_name" {
  value = local.create_key_pair ? module.key_pair[0].key_name : null
}
