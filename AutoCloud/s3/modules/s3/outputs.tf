# ─────────────────────────────────────────────
# modules/s3/outputs.tf
# ─────────────────────────────────────────────

output "bucket_id" {
  description = "The name (ID) of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name (global)"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Bucket regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
}

output "encryption_algorithm" {
  description = "SSE algorithm in use"
  value       = "aws:kms"
}
