variable "account_ids" {
  description = "Map of landing-zone account keys to AWS account IDs."
  type        = map(string)
  default     = {}
}

variable "ou_ids" {
  description = "Map of organizational unit names to OU IDs."
  type        = map(string)
  default     = {}
}

variable "service_control_policies" {
  description = "Map of active service control policy definitions keyed by policy key."
  type = map(object({
    description     = string
    name            = string
    policy_file     = string
    substitutions   = map(string)
    target_ous      = optional(list(string), [])
    target_accounts = optional(list(string), [])
  }))
  default = {}
}
