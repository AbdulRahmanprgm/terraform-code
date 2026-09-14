variable "aws_region" {

  description = "Terraform execution region"
  type        = string

}

variable "global_cidr" {

  description = "Global CIDR block"
  type        = string
  default     = "10.0.0.0/8"

}

variable "global_pool_name" {

  description = "Name of global IPAM pool"
  type        = string

}

variable "operating_regions" {

  description = "Regions where IPAM operates"
  type        = list(string)

}

variable "environment_pools" {

  description = "Environment names"
  type        = list(string)

}

variable "vpc_netmask_length" {

  description = "VPC CIDR mask"
  type        = number
  default     = 20

  validation {
    condition     = var.vpc_netmask_length >= 0 && var.vpc_netmask_length <= 32
    error_message = "The VPC netmask length must be between 0 and 32."
  }

}

variable "subnet_netmask_length" {

  description = "Subnet CIDR mask"
  type        = number
  default     = 24

  validation {
    condition     = var.subnet_netmask_length >= var.vpc_netmask_length && var.subnet_netmask_length <= 32
    error_message = "The subnet netmask length must be greater than or equal to the VPC netmask length and no greater than 32."
  }

}

variable "default_tags" {
  description = "Map of default tags to apply to all resources"
  type        = map(string)
}
