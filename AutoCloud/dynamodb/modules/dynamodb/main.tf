terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

locals {
  partition_key_name = trimspace(var.partition_key.name)
  sort_key_name      = var.sort_key == null ? null : trimspace(var.sort_key.name)

  key_attributes = concat(
    [
      {
        name = local.partition_key_name
        type = var.partition_key.type
      }
    ],
    local.sort_key_name == null ? [] : [
      {
        name = local.sort_key_name
        type = var.sort_key.type
      }
    ]
  )
}

resource "aws_dynamodb_table" "this" {

  name                        = trimspace(var.table_name)
  billing_mode                = var.billing_mode
  hash_key                    = local.partition_key_name
  range_key                   = local.sort_key_name
  read_capacity               = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity              = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  table_class                 = var.table_class
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = local.key_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}
