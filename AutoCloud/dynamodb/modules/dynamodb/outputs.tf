output "table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "The ARN of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "The ID of the DynamoDB table."
  value       = aws_dynamodb_table.this.id
}

output "partition_key" {
  description = "The partition key configured on the DynamoDB table."
  value       = aws_dynamodb_table.this.hash_key
}

output "sort_key" {
  description = "The sort key configured on the DynamoDB table, if any."
  value       = aws_dynamodb_table.this.range_key
}
