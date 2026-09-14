output "table_name" {
  description = "The DynamoDB table name created by the module."
  value       = module.dynamodb.table_name
}

output "table_arn" {
  description = "The DynamoDB table ARN created by the module."
  value       = module.dynamodb.table_arn
}

output "table_id" {
  description = "The DynamoDB table ID created by the module."
  value       = module.dynamodb.table_id
}

output "partition_key" {
  description = "The partition key configured on the DynamoDB table."
  value       = module.dynamodb.partition_key
}

output "sort_key" {
  description = "The sort key configured on the DynamoDB table, if any."
  value       = module.dynamodb.sort_key
}
