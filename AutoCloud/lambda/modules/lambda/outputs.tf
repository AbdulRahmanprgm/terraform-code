output "function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "The ARN of the Lambda function."
  value       = aws_lambda_function.this.arn
}

output "function_invoke_arn" {
  description = "The invoke ARN of the Lambda function."
  value       = aws_lambda_function.this.invoke_arn
}

output "role_arn" {
  description = "The IAM role ARN attached to the Lambda function."
  value       = local.lambda_role_arn
}
