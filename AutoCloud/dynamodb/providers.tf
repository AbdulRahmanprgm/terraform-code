provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "DynamoDB"
      ManagedBy   = "terraform"
      Owner       = "platform-team"
    }
  }
}
