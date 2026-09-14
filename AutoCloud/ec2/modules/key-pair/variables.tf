variable "key_name" {
  description = "Name of the AWS key pair."
  type        = string
}

variable "public_key" {
  description = "Public key material used for the AWS key pair."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the key pair."
  type        = map(string)
  default     = {}
}
