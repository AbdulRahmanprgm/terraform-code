provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "landing-zone"
      ManagedBy   = "terraform"
      Owner       = "platform-team"
    }
  }
}
