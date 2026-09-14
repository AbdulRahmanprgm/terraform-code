aws_region = "us-east-1"

table_name = "customer-enterprise"

partition_key = {
  name = "id"
  type = "S"
}

# sort_key = {
#   name = "value"
#   type = "value"
# }

billing_mode = "PAY_PER_REQUEST"
# billing_mode = "PROVISIONED"

# read_capacity  = 10
# write_capacity = 5

table_class = "STANDARD"
# table_class = "STANDARD_INFREQUENT_ACCESS"

point_in_time_recovery_enabled = true
deletion_protection_enabled    = false

default_tags = {
  ManagedBy = "Terraform"
  Workload  = "customer-enterprise"
}
