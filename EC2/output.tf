output "instance_public_ip" {
  value = "ssh -i mykey ec2-user@${aws_instance.my.public_ip}"
}

output "instance_public_dns" {
  value = aws_instance.my.public_dns
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "security_group_id" {
  value = aws_security_group.allow_All.id
}

output "key_name" {
  value = aws_key_pair.name.key_name
}