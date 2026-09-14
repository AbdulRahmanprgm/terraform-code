variable "aws_region" {
  type = string
}

variable "keep_last_images" {
  type = number
}

variable "image_tag_mutability" {
  type = string
}

variable "repositories" {
  type = list(string)
}

variable "default_tags" {
  description = "Map of default tags to apply to all resources"
  type        = map(string)
}
