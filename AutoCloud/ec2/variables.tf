variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for a newly created subnet."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name for the EC2 instance and related resources."
  type        = string

  validation {
    condition     = trimspace(var.instance_name) != ""
    error_message = "The instance_name cannot be empty."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Leave empty to use the latest Amazon-owned Amazon Linux 2023 AMI."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.ami_id) == "" || can(regex("^ami-[a-f0-9]+$", trimspace(var.ami_id)))
    error_message = "The ami_id must be empty or a valid AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "monitoring" {
  description = "Enable detailed monitoring for the EC2 instance."
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size > 0
    error_message = "The root_volume_size must be greater than 0."
  }
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "create_vpc" {
  description = "Whether to create a new VPC."
  type        = bool
  default     = false
}

variable "create_subnet" {
  description = "Whether to create a new subnet."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for a newly created VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for a newly created subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "create_security_group" {
  description = "Whether to create a new security group."
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "ID of an existing subnet to use when create_subnet is false, or to discover the existing VPC when create_vpc is false."
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "Existing security group IDs to attach when create_security_group is false."
  type        = list(string)
  default     = []
}

variable "allowed_cidr" {
  description = "CIDR blocks allowed to connect over OS-specific administrator access when create_security_group is true."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.allowed_cidr : can(cidrhost(cidr, 0))])
    error_message = "The allowed_cidr must contain only valid CIDR blocks."
  }
}

variable "public_key_path" {
  description = "Path to the public key file used to create the EC2 key pair. Leave empty to skip key-pair creation."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.public_key_path) == "" || fileexists(trimspace(var.public_key_path))
    error_message = "The public_key_path must be empty or point to an existing public key file."
  }
}

variable "user_data_file" {
  description = "Path to the user data script file. Leave empty to skip user data."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.user_data_file) == "" || fileexists(trimspace(var.user_data_file))
    error_message = "The user_data_file must be empty or point to an existing file."
  }
}

variable "use_elastic_ip" {
  description = "Whether to allocate and associate an Elastic IP to the instance."
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "Whether AWS should auto-assign a public IP address to the instance."
  type        = bool
  default     = false
}

variable "default_tags" {
  description = "Default tags to apply to all resources."
  type        = map(string)
  default     = {}
}
