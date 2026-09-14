aws_region  = "us-east-1"
bucket_name = "company-prod-app-data-1"

block_public_access = true
versioning_enabled  = true

lifecycle_enabled                     = true
lifecycle_transition_days_standard_ia = 30
lifecycle_transition_days_glacier     = 90
lifecycle_expiration_days             = 365

default_tags = {
  Project   = "EnterprisePlatform"
  Owner     = "DevOpsTeam"
  ManagedBy = "Terraform"
}
