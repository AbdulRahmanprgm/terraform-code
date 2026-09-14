output "topic_arn" {
  description = "ARN of the SNS topic"
  value       = var.fifo_topic ? aws_sns_topic.this_fifo[0].arn : aws_sns_topic.this.arn
}

output "topic_name" {
  description = "Name of the SNS topic"
  value       = var.fifo_topic ? aws_sns_topic.this_fifo[0].name : aws_sns_topic.this.name
}

output "email_subscription_arns" {
  description = "ARNs of email subscriptions"
  value       = aws_sns_topic_subscription.email[*].arn
}

output "sms_subscription_arns" {
  description = "ARNs of SMS subscriptions"
  value       = aws_sns_topic_subscription.sms[*].arn
}
