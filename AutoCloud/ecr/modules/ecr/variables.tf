variable "repositories" {
  description = "ECR repository names"
  type        = list(string)
}

variable "keep_last_images" {
  type = number
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for ECR repositories (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability must be either 'MUTABLE' or 'IMMUTABLE'."
  }
}

variable "default_tags" {
  description = "Map of default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
