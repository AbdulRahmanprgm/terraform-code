terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

resource "aws_sns_topic" "this" {
  name              = var.topic_name
  fifo_topic        = var.fifo_topic
  display_name      = var.display_name
  kms_master_key_id = var.encryption_enabled ? "alias/aws/sns" : null
  tags              = var.tags
}

resource "aws_sns_topic" "this_fifo" {
  count                       = var.fifo_topic ? 1 : 0
  name                        = var.topic_name
  fifo_topic                  = true
  content_based_deduplication = var.content_based_deduplication
  display_name                = var.display_name
  kms_master_key_id           = var.encryption_enabled ? "alias/aws/sns" : null
  tags                        = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count                  = var.create_email_subscription ? length(var.email_endpoints) : 0
  topic_arn              = var.fifo_topic ? aws_sns_topic.this_fifo[0].arn : aws_sns_topic.this.arn
  protocol               = "email"
  endpoint               = var.email_endpoints[count.index]
  endpoint_auto_confirms = false
}

resource "aws_sns_topic_subscription" "sms" {
  count     = var.create_sms_subscription ? length(var.sms_endpoints) : 0
  topic_arn = var.fifo_topic ? aws_sns_topic.this_fifo[0].arn : aws_sns_topic.this.arn
  protocol  = "sms"
  endpoint  = var.sms_endpoints[count.index]
}
