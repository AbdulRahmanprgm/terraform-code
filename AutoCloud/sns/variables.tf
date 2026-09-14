variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "topic_name" {
  description = "The name of the SNS topic"
  type        = string
}

variable "fifo_topic" {
  description = "Whether to create a FIFO SNS topic"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics"
  type        = bool
  default     = false
}

variable "create_email_subscription" {
  description = "Whether to create email subscriptions"
  type        = bool
  default     = false
}

variable "email_endpoints" {
  description = "List of email addresses for subscriptions"
  type        = list(string)
  default     = []
}

variable "create_sms_subscription" {
  description = "Whether to create SMS subscriptions"
  type        = bool
  default     = false
}

variable "sms_endpoints" {
  description = "List of phone numbers for SMS subscriptions"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}

variable "encryption_enabled" {
  description = "Enable AWS-managed KMS encryption for SNS"
  type        = bool
  default     = false
}
