# backend.tf - Optional remote backend configuration
# Uncomment and update the settings below to configure an S3 backend.
# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "lambda/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
