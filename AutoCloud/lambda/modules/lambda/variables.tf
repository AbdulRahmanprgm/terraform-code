variable "function_name" {
  description = "Name of the Lambda function."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.function_name)) && length(var.function_name) <= 64
    error_message = "The Function name must be 1-64 characters and contain only letters, numbers, hyphens, and underscores."
  }
}

variable "package_type" {
  description = "Package type for the Lambda function deployment ('Zip' or 'Image')."
  type        = string
  default     = "Zip"

  validation {
    condition     = contains(["Zip", "Image"], var.package_type)
    error_message = "The Package type must be either 'Zip' or 'Image'."
  }
}

variable "runtime" {
  description = "Runtime identifier for Zip package Lambda functions."
  type        = string
  default     = "nodejs24.x"
}

variable "handler" {
  description = "Handler entry point for Zip package Lambda functions."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "source_path" {
  description = "Path to the deployment package zip file for Zip package Lambda functions."
  type        = string
  default     = "payload.zip"
}

variable "image_uri" {
  description = "Container image URI for Image package Lambda deployment."
  type        = string
  default     = ""
}

variable "create_role" {
  description = "Whether Terraform should create an IAM role for Lambda execution."
  type        = bool
  default     = true
}

variable "arm64_enabled" {
  description = "Whether the Lambda function should use the ARM64 architecture (true for arm64, false for x86_64)."
  type        = bool
  default     = false
}

variable "kms_enabled" {
  description = "Whether to enable KMS key encryption for Lambda environment variables and log groups."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN of an existing customer-managed KMS key. If empty and kms_enabled is true, a new KMS key will be created."
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB allocated to the Lambda function (128 to 10240)."
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "The Memory size must be between 128 MB and 10240 MB."
  }
}

variable "timeout" {
  description = "Execution timeout in seconds for the Lambda function (1 to 900)."
  type        = number
  default     = 3

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "The Timeout must be between 1 and 900 seconds."
  }
}

variable "default_tags" {
  description = "A map of default tags applied to all supported AWS resources."
  type        = map(string)
  default     = {}
}
