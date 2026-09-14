# ─────────────────────────────────────────────────────────────────────────────
# Computed Locals
#
# All derived values are centralised here to keep main.tf clean.
# ─────────────────────────────────────────────────────────────────────────────

locals {
  # ── Recipe name derived from pipeline_name ─────────────────────────────────
  recipe_name    = "${var.pipeline_name}-recipe"
  recipe_version = "1.0.1"

  # ── AWS-managed baseline component ─────────────────────────────────────────
  # Image Builder requires at least one component in every recipe.
  # The AWS-managed update-linux component applies OS security patches on every
  # build, satisfying the minimum requirement even when no custom component is
  # supplied. The "x.x.x" version selector always resolves to the latest version.
  update_linux_component_arn = "arn:aws:imagebuilder:${var.aws_region}:aws:component/update-linux/x.x.x"

  # ── Build networking defaults ──────────────────────────────────────────────
  build_vpc_id             = length(var.vpc_id) > 0 ? var.vpc_id : data.aws_vpc.default.id
  build_subnet_ids         = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.default.ids
  build_subnet_id          = length(var.subnet_ids) > 0 ? var.subnet_ids[0] : data.aws_subnets.default.ids[0]
  build_security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : [aws_security_group.image_builder.id]
  build_security_group_id  = local.build_security_group_ids[0]

  # ── Conditional schedule ──────────────────────────────────────────────────
  enable_schedule = var.schedule_type == "SCHEDULE"
}
