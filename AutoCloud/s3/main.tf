# ─────────────────────────────────────────────
# Root – main.tf
# Instantiates the S3 module with all parameters
# ─────────────────────────────────────────────

module "s3" {
  source = "./modules/s3"

  bucket_name         = var.bucket_name
  block_public_access = var.block_public_access

  versioning_enabled = var.versioning_enabled

  lifecycle_enabled                            = var.lifecycle_enabled
  lifecycle_transition_days_standard_ia        = var.lifecycle_transition_days_standard_ia
  lifecycle_transition_days_glacier            = var.lifecycle_transition_days_glacier
  lifecycle_expiration_days                    = var.lifecycle_expiration_days
  lifecycle_noncurrent_version_expiration_days = var.lifecycle_noncurrent_version_expiration_days

  tags = var.default_tags
}
