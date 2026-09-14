variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "block_public_access" {
  description = "Enable S3 Block Public Access settings on the bucket"
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle rules on the S3 bucket"
  type        = bool
  default     = true
}

variable "lifecycle_noncurrent_version_expiration_days" {
  description = "Days after which noncurrent versions are permanently deleted"
  type        = number
  default     = 90
}

variable "lifecycle_transition_days_standard_ia" {
  description = "Days after which objects transition to STANDARD_IA"
  type        = number
  default     = 30
}

variable "lifecycle_transition_days_glacier" {
  description = "Days after which objects transition to GLACIER"
  type        = number
  default     = 90
}

variable "lifecycle_expiration_days" {
  description = "Days after which objects are permanently deleted (0 = disabled)"
  type        = number
  default     = 365
}

variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default     = {}
}
