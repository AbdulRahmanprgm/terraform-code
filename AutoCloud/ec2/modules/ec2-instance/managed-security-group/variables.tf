variable "instance_name" {
  description = "Name tag for the EC2 instance and related resources."
  type        = string
}

variable "ami_id" {
  description = "Resolved AMI ID for the EC2 instance."
  type        = string
}

variable "ami_is_windows" {
  description = "Whether the selected AMI is Windows."
  type        = bool
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
  description = "Subnet ID where the instance will be launched."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the managed security group."
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR blocks allowed to connect over OS-specific administrator access."
  type        = list(string)
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
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether AWS should auto-assign a public IP address to the instance."
  type        = bool
}

variable "use_elastic_ip" {
  description = "Whether to allocate and attach an Elastic IP."
  type        = bool
}

variable "tags" {
  description = "Tags to apply to supported EC2 resources."
  type        = map(string)
}
