output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = module.sns.topic_arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = module.sns.topic_name
}

output "email_subscription_arns" {
  description = "ARNs of email subscriptions"
  value       = module.sns.email_subscription_arns
}

output "sms_subscription_arns" {
  description = "ARNs of SMS subscriptions"
  value       = module.sns.sms_subscription_arns
}
