variable "instance_name" {
  description = "Name tag for the EC2 instance and related resources."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Leave empty to use the latest Amazon-owned Amazon Linux 2023 AMI."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.ami_id) == "" || can(regex("^ami-[a-f0-9]+$", trimspace(var.ami_id)))
    error_message = "The AMI ID must be empty or a valid AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair. Null launches the instance without a key pair."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched. Must belong to a non-default VPC."
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-f0-9]+$", var.subnet_id))
    error_message = "The subnet_id must be a valid AWS subnet ID."
  }
}

variable "security_group_ids" {
  description = "List of pre-existing security group IDs used when create_security_group is false."
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Whether to create a managed security group for the instance."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID used when create_security_group is true."
  type        = string
  default     = null
}

variable "allowed_cidr" {
  description = "CIDR blocks allowed to connect over OS-specific administrator access when create_security_group is true."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.allowed_cidr : can(cidrhost(cidr, 0))])
    error_message = "The Allowed CIDR must contain only valid CIDR blocks."
  }
}

variable "monitoring" {
  description = "Enable detailed CloudWatch monitoring."
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script to provide when launching the instance."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Tags to apply to supported EC2 module resources."
  type        = map(string)
  default     = {}
}

variable "associate_public_ip_address" {
  description = "Whether AWS should auto-assign a public IP address to the instance."
  type        = bool
  default     = false
}

variable "use_elastic_ip" {
  description = "Whether to allocate and attach an Elastic IP."
  type        = bool
  default     = false
}
