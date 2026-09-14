variable "accounts" {
  description = "Map of landing-zone accounts keyed by account identifier. Every entry creates a new AWS Organizations account."
  type = map(object({
    name  = string
    email = string
    ou    = string
  }))
  default = {}
}

variable "ou_ids" {
  description = "Map of organizational unit names to OU IDs."
  type        = map(string)
  default     = {}
}

variable "close_on_deletion" {
  description = "Whether accounts should be closed when Terraform destroys them."
  type        = bool
  default     = false
}
