terraform {
  required_version = ">= 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

data "aws_organizations_organization" "current" {}

data "aws_organizations_organizational_units" "root" {
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

locals {
  existing_ou_ids = {
    for ou in data.aws_organizations_organizational_units.root.children :
    ou.name => ou.id
    if contains(keys(var.organizational_units), ou.name)
  }

  missing_organizational_units = {
    for ou_name, child_ous in var.organizational_units :
    ou_name => child_ous
    if !contains(keys(local.existing_ou_ids), ou_name)
  }

  ou_ids = merge(
    local.existing_ou_ids,
    {
      for ou_name, ou in aws_organizations_organizational_unit.this :
      ou_name => ou.id
    }
  )
}

resource "aws_organizations_organizational_unit" "this" {
  for_each = local.missing_organizational_units

  name      = each.key
  parent_id = data.aws_organizations_organization.current.roots[0].id
}
