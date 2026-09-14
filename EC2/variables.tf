variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}
variable "instance_name" {
  description = "name of the intance"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance."
  type        = string
}