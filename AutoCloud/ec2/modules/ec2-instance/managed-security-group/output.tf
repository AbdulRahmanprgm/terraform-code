output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the instance."
  value       = var.use_elastic_ip ? aws_eip.this[0].public_ip : (var.associate_public_ip_address ? aws_instance.this.public_ip : null)
}

output "elastic_ip" {
  description = "Elastic IP address (non-empty only when use_elastic_ip=true)"
  value       = var.use_elastic_ip ? aws_eip.this[0].public_ip : null
}

output "private_ip" {
  value = aws_instance.this.private_ip
}

output "security_group_ids" {
  description = "Security group IDs attached to the instance."
  value       = [aws_security_group.this.id]
}
