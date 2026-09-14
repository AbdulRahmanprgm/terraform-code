variable "aws_region" {
  description = "Primary AWS region for landing-zone controls and SCP region restrictions."
  type        = string
}

variable "allowed_regions" {
  description = "AWS regions allowed for resource creation"
  type        = list(string)
  default     = ["ap-south-1"]
}

variable "create_organization" {
  description = "Whether Terraform should create a new AWS Organization instead of reusing the existing one."
  type        = bool
  default     = false
}

variable "close_on_deletion" {
  description = "Whether AWS accounts should be closed when the Terraform resource is destroyed."
  type        = bool
  default     = false
}

variable "organizational_units" {
  description = "Map of top-level organizational units keyed by OU name."
  type        = map(list(string))
  default     = {}
}

variable "accounts" {
  description = "Map of landing-zone accounts keyed by account identifier. Every entry creates a new AWS Organizations account."
  type = map(object({
    name  = string
    email = string
    ou    = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for account in values(var.accounts) :
      contains(keys(var.organizational_units), account.ou)
    ])
    error_message = "Each accounts[*].ou value must match a key in organizational_units."
  }

  validation {
    condition = alltrue([
      for account in values(var.accounts) :
      length(trimspace(account.email)) > 0
    ])
    error_message = "Each account must set a non-empty email address."
  }

  validation {
    condition = alltrue([
      for account in values(var.accounts) :
      length(regexall("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", trimspace(account.email))) == 1
    ])
    error_message = "Each account must set a valid email address."
  }

  validation {
    condition = length(distinct([
      for account in values(var.accounts) :
      lower(trimspace(account.email))
    ])) == length(var.accounts)
    error_message = "Each account must use a unique email address."
  }
}
