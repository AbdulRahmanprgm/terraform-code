# ─────────────────────────────────────────────
# Root – outputs.tf
# ─────────────────────────────────────────────

output "bucket_id" {
  description = "The name / ID of the S3 bucket"
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = module.s3.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Bucket regional domain name"
  value       = module.s3.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = module.s3.versioning_enabled
}

output "encryption_algorithm" {
  description = "Server-side encryption algorithm in use"
  value       = module.s3.encryption_algorithm
}
