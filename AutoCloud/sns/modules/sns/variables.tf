variable "topic_name" {
  description = "The name of the SNS topic"
  type        = string
  nullable    = false

  validation {
    condition     = length(var.topic_name) > 0
    error_message = "Topic name cannot be empty."
  }

  validation {
    condition = (
      var.fifo_topic ? endswith(var.topic_name, ".fifo") : !endswith(var.topic_name, ".fifo")
    )
    error_message = "FIFO topic must end with .fifo, standard topic must not end with .fifo."
  }
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

variable "display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = ""
}

variable "encryption_enabled" {
  description = "Enable AWS-managed KMS encryption for SNS"
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

variable "tags" {
  description = "Tags to apply to the SNS topic"
  type        = map(string)
  default     = {}
}
