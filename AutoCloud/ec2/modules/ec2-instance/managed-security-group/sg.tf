resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Managed security group for the ${var.instance_name} EC2 instance"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.instance_name}-sg"
  })
}

locals {
  linux_ingress_rule_specs = [
    {
      name        = "ssh"
      description = "SSH"
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4s  = distinct(var.allowed_cidr)
    },
    {
      name        = "http"
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4s  = ["0.0.0.0/0"]
    },
    {
      name        = "https"
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4s  = ["0.0.0.0/0"]
    },
    {
      name        = "dns-udp"
      description = "DNS over UDP"
      from_port   = 53
      to_port     = 53
      ip_protocol = "udp"
      cidr_ipv4s  = ["0.0.0.0/0"]
    },
    {
      name        = "dns-tcp"
      description = "DNS over TCP"
      from_port   = 53
      to_port     = 53
      ip_protocol = "tcp"
      cidr_ipv4s  = ["0.0.0.0/0"]
    }
  ]

  windows_ingress_rule_specs = [
    {
      name        = "rdp"
      description = "RDP"
      from_port   = 3389
      to_port     = 3389
      ip_protocol = "tcp"
      cidr_ipv4s  = distinct(var.allowed_cidr)
    },
    {
      name        = "http"
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4s  = ["0.0.0.0/0"]
    },
    {
      name        = "https"
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4s  = ["0.0.0.0/0"]
    }
  ]

  selected_ingress_rule_specs = var.ami_is_windows ? local.windows_ingress_rule_specs : local.linux_ingress_rule_specs

  security_group_ingress_rules = {
    for rule in flatten([
      for rule in local.selected_ingress_rule_specs : [
        for cidr_ipv4 in rule.cidr_ipv4s : merge(rule, {
          cidr_ipv4 = cidr_ipv4
          key       = "${rule.name}-${rule.ip_protocol}-${rule.from_port}-${rule.to_port}-${replace(replace(cidr_ipv4, ".", "_"), "/", "_")}"
        })
      ]
    ]) : rule.key => rule
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.security_group_ingress_rules

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
