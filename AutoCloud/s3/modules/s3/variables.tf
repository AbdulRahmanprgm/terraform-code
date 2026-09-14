# ─────────────────────────────────────────────
# modules/s3/variables.tf
# ─────────────────────────────────────────────

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "block_public_access" {
  description = "Enable all four S3 Block Public Access settings"
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle rules"
  type        = bool
  default     = true
}

variable "lifecycle_transition_days_standard_ia" {
  description = "Days until objects move to STANDARD_IA"
  type        = number
  default     = 30
}

variable "lifecycle_transition_days_glacier" {
  description = "Days until objects move to GLACIER"
  type        = number
  default     = 90
}

variable "lifecycle_expiration_days" {
  description = "Days until current objects expire (0 = disabled)"
  type        = number
  default     = 365
}

variable "lifecycle_noncurrent_version_expiration_days" {
  description = "Days until noncurrent versions are permanently deleted"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to the bucket and related resources"
  type        = map(string)
  default     = {}
}
