module "sns" {
  source = "./modules/sns"

  topic_name                  = var.topic_name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  encryption_enabled          = var.encryption_enabled
  create_email_subscription   = var.create_email_subscription
  email_endpoints             = var.email_endpoints
  create_sms_subscription     = var.create_sms_subscription
  sms_endpoints               = var.sms_endpoints
  tags                        = var.default_tags
}
