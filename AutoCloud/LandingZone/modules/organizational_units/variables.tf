variable "organizational_units" {
  description = "Map of top-level organizational units keyed by OU name."
  type        = map(list(string))
  default     = {}
}
