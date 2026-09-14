output "subnet_id" {
  description = "Subnet ID for EC2 placement."
  value       = local.subnet_id
}

output "vpc_id" {
  description = "VPC ID."
  value       = local.vpc_id
}
