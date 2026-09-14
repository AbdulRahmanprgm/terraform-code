output "function_name" {
  description = "The name of the deployed Lambda function."
  value       = module.lambda.function_name
}

output "function_arn" {
  description = "The ARN of the deployed Lambda function."
  value       = module.lambda.function_arn
}

output "function_invoke_arn" {
  description = "The invoke ARN for the deployed Lambda function."
  value       = module.lambda.function_invoke_arn
}

output "role_arn" {
  description = "The IAM execution role ARN for the Lambda function."
  value       = module.lambda.role_arn
}
