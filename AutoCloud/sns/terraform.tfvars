aws_region = "us-east-1"

topic_name = "application-alerts"

fifo_topic                  = false
content_based_deduplication = false
encryption_enabled          = false

create_email_subscription = true
email_endpoints = [
  "jetleejetlee100@gmail.com"
]

create_sms_subscription = false
sms_endpoints           = []

default_tags = {
  ManagedBy = "Terraform"
}
