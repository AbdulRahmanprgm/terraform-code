terraform {
  required_version = ">= 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_organizations_account" "this" {
  for_each = var.accounts

  name                       = each.value.name
  email                      = each.value.email
  parent_id                  = var.ou_ids[each.value.ou]
  role_name                  = "OrganizationAccountAccessRole"
  iam_user_access_to_billing = "ALLOW"
  close_on_deletion          = var.close_on_deletion

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = each.value.name
  }
}
