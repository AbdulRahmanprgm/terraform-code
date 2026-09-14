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

variable "subnet_id" {
  description = "Existing subnet ID to use when create_subnet is false, or to discover the existing VPC when create_vpc is false."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for a newly created VPC."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for a newly created subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for a newly created subnet."
  type        = string
}

variable "public_access_enabled" {
  description = "Whether public internet routing is needed for newly created networking."
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "Instance name used for resource naming."
  type        = string
}

variable "aws_region" {
  description = "AWS region used for availability zone and flow-log service names."
  type        = string
}

variable "tags" {
  description = "Tags to apply to supported network resources."
  type        = map(string)
  default     = {}
}
