# ── Pipeline ──────────────────────────────────────────────────────────────────

output "pipeline_arn" {
  description = "ARN of the EC2 Image Builder image pipeline."
  value       = aws_imagebuilder_image_pipeline.this.arn
}

output "pipeline_name" {
  description = "Name of the Image Builder pipeline."
  value       = aws_imagebuilder_image_pipeline.this.name
}

# ── Recipe ────────────────────────────────────────────────────────────────────

output "recipe_arn" {
  description = "ARN of the image recipe."
  value       = aws_imagebuilder_image_recipe.this.arn
}

output "recipe_name" {
  description = "Name of the image recipe (derived from pipeline_name)."
  value       = aws_imagebuilder_image_recipe.this.name
}

# ── Infrastructure & Distribution ─────────────────────────────────────────────

output "infra_config_arn" {
  description = "ARN of the infrastructure configuration."
  value       = aws_imagebuilder_infrastructure_configuration.this.arn
}

output "distribution_config_arn" {
  description = "ARN of the distribution configuration."
  value       = aws_imagebuilder_distribution_configuration.this.arn
}

# ── IAM ───────────────────────────────────────────────────────────────────────

output "iam_role_arn" {
  description = "ARN of the IAM role used by build instances."
  value       = aws_iam_role.image_builder.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile used by build instances."
  value       = aws_iam_instance_profile.image_builder.name
}
