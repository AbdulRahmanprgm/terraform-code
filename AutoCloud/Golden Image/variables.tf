variable "aws_region" {
  description = "AWS region where all Image Builder resources are provisioned."
  type        = string
}

variable "pipeline_name" {
  description = "Name of the Image Builder pipeline. Also used as a prefix for all child resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,125}$", var.pipeline_name))
    error_message = "Thepipeline_name must be 1–126 characters: alphanumeric, hyphens, or underscores."
  }
}

variable "schedule_type" {
  description = "Pipeline trigger: MANUAL (on-demand via console/CLI) or SCHEDULE (cron/rate expression)."
  type        = string
  default     = "MANUAL"

  validation {
    condition     = contains(["MANUAL", "SCHEDULE"], var.schedule_type)
    error_message = "The schedule_type must be 'MANUAL' or 'SCHEDULE'."
  }
}

variable "schedule_expression" {
  description = "AWS EventBridge cron or rate expression. Required only when schedule_type = 'SCHEDULE'. Example: cron(0 2 ? * SUN *)"
  type        = string
  default     = ""
}

variable "base_image" {
  description = "Source AMI ID used as the parent image for the recipe (e.g. ami-0b6d9d3d33ba97d99)."
  type        = string

  validation {
    condition     = can(regex("^ami-[a-f0-9]{8,17}$", var.base_image))
    error_message = "The base_image must be a valid AMI ID (e.g. ami-0b6d9d3d33ba97d99)."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the build instance."
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
  default     = 30

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "The root_volume_size must be between 8 and 16384 GB."
  }
}

variable "root_volume_type" {
  description = "EBS volume type for the root block device (gp3, gp2, io1, io2, standard)."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "io1", "io2", "standard"], var.root_volume_type)
    error_message = "The root_volume_type must be one of: gp3, gp2, io1, io2, standard."
  }
}

variable "default_tags" {
  description = "Map of tags applied to all taggable AWS resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "Optional VPC ID for Image Builder build instances. Uses the default VPC if unset."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Optional subnet IDs for Image Builder build instances and SSM interface endpoints. Uses default VPC subnets if unset."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Optional security group IDs for the build instance. If unset, a dedicated security group is created."
  type        = list(string)
  default     = []
}
