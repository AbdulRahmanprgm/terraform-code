module "dynamodb" {
  source = "./modules/dynamodb"

  table_name                     = var.table_name
  partition_key                  = var.partition_key
  sort_key                       = var.sort_key
  billing_mode                   = var.billing_mode
  read_capacity                  = var.read_capacity
  write_capacity                 = var.write_capacity
  table_class                    = var.table_class
  deletion_protection_enabled    = var.deletion_protection_enabled
  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
  tags                           = var.default_tags
}
