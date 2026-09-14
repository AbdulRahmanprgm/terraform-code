aws_region = "us-east-1"

pipeline_name = "golden-image-pipeline"

# MANUAL | SCHEDULE
schedule_type = "MANUAL"

# Required only when schedule_type = "SCHEDULE"
# Example: schedule_expression = "cron(0 2 ? * SUN *)"
schedule_expression = ""

# ── Image Recipe ─────────────────────────────────────────
base_image = "ami-0b6d9d3d33ba97d99"

instance_type = "t2.micro"

root_volume_size = 30
root_volume_type = "gp3"

default_tags = {
  ManagedBy   = "Terraform"
  Environment = "Dev"
  Project     = "GoldenImage"
}
