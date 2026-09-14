variable "aws_region" {
  type        = string
  description = "AWS region used by the AWS provider."
  default     = "us-east-1"
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table."

  validation {
    condition     = length(trimspace(var.table_name)) > 0
    error_message = "Table name cannot be empty."
  }
}

variable "partition_key" {
  type = object({
    name = string
    type = string
  })
  description = "Partition key definition for the DynamoDB table."
  default = {
    name = "id"
    type = "S"
  }

  validation {
    condition     = length(trimspace(var.partition_key.name)) > 0
    error_message = "Partition key name cannot be empty."
  }

  validation {
    condition     = contains(["S", "N", "B"], var.partition_key.type)
    error_message = "Partition key type must be one of S, N, or B."
  }
}

variable "sort_key" {
  type = object({
    name = string
    type = string
  })
  description = "Optional sort key definition for the DynamoDB table. Set to null to create a table without a sort key."
  default     = null

  validation {
    condition     = var.sort_key == null ? true : length(trimspace(var.sort_key.name)) > 0
    error_message = "Sort key name must be non-empty when sort key is set."
  }

  validation {
    condition     = var.sort_key == null ? true : contains(["S", "N", "B"], var.sort_key.type)
    error_message = "Sort key type must be one of S, N, or B."
  }
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB billing mode."
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "Billing mode must be either PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "read_capacity" {
  type        = number
  description = "Read capacity units. Required for PROVISIONED billing mode and must be null for PAY_PER_REQUEST."
  default     = null

  validation {
    condition     = var.read_capacity == null ? true : var.read_capacity >= 1 && floor(var.read_capacity) == var.read_capacity
    error_message = "Read capacity must be a positive whole number when set."
  }
}

variable "write_capacity" {
  type        = number
  description = "Write capacity units. Required for PROVISIONED billing mode and must be null for PAY_PER_REQUEST."
  default     = null

  validation {
    condition     = var.write_capacity == null ? true : var.write_capacity >= 1 && floor(var.write_capacity) == var.write_capacity
    error_message = "Write capacity must be a positive whole number when set."
  }
}

variable "table_class" {
  type        = string
  description = "DynamoDB table class."
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "Table class must be either STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Enable deletion protection for the DynamoDB table."
  default     = false
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable point-in-time recovery for the DynamoDB table."
  default     = true
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to resources."
  default = {
    ManagedBy = "Terraform"
  }

  validation {
    condition     = alltrue([for key, value in var.default_tags : length(trimspace(key)) > 0])
    error_message = "Default tag keys cannot be empty."
  }
}
