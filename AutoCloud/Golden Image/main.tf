data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_kms_key" "image_builder" {
  description             = "CMK for EC2 Image Builder"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAccountRootFullAccess"
        Effect    = "Allow"
        Principal = { AWS = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"] }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowImageBuilderInstanceRoleUse"
        Effect    = "Allow"
        Principal = { AWS = [aws_iam_role.image_builder.arn] }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ListGrants"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowAWSServicePrincipalsToUseKey"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "imagebuilder.amazonaws.com"
          ]
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ListGrants"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:CallerAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  tags = var.default_tags
}

resource "aws_kms_alias" "image_builder" {
  name          = "alias/${var.pipeline_name}"
  target_key_id = aws_kms_key.image_builder.key_id
}

resource "aws_security_group" "image_builder" {
  name        = "${var.pipeline_name}-sg"
  description = "Security group for Image Builder build instances and SSM interface endpoints."
  vpc_id      = local.build_vpc_id

  ingress {
    description = "Allow build instance to connect to SSM interface endpoints over HTTPS."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "Allow HTTPS access to SSM and package endpoints."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS resolution for build instances."
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS resolution over TCP for zone transfers if needed."
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = local.build_vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.build_subnet_ids
  security_group_ids  = [local.build_security_group_id]
  private_dns_enabled = false
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = local.build_vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.build_subnet_ids
  security_group_ids  = [local.build_security_group_id]
  private_dns_enabled = false
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = local.build_vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.build_subnet_ids
  security_group_ids  = [local.build_security_group_id]
  private_dns_enabled = false
}

# ── IAM Role & Instance Profile ───────────────────────────────────────────────

resource "aws_iam_role" "image_builder" {
  name        = "${var.pipeline_name}-role"
  description = "Execution role for EC2 Image Builder build instances (${var.pipeline_name})."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowEC2AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.default_tags
}

# Grants Image Builder permissions to orchestrate the build: download
resource "aws_iam_role_policy_attachment" "image_builder_core" {
  role       = aws_iam_role.image_builder.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

# Grants SSM Agent permissions so Image Builder can execute AWSTOE
# components on the build instance via Systems Manager.
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.image_builder.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile is the mechanism that attaches an IAM role to an EC2 instance.
resource "aws_iam_instance_profile" "image_builder" {
  name = "${var.pipeline_name}-instance-profile"
  role = aws_iam_role.image_builder.name

  tags = var.default_tags
}

# ── Image Recipe ──────────────────────────────────────────────────────────────

resource "aws_imagebuilder_image_recipe" "this" {
  name         = local.recipe_name
  version      = local.recipe_version
  parent_image = var.base_image
  description  = "Image recipe for ${var.pipeline_name} — base image ${var.base_image}."

  # ── Components ─────────────────────────────────────────────────────────────
  # Image Builder requires at least one component per recipe.
  # The AWS-managed update-linux component applies OS security patches on every build.
  component {
    component_arn = local.update_linux_component_arn
  }

  # ── Root Block Device ──────────────────────────────────────────────────────
  block_device_mapping {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      encrypted             = true
      kms_key_id            = aws_kms_key.image_builder.arn
    }
  }

  tags = var.default_tags

  lifecycle {
    create_before_destroy = true
  }
}

# ── Infrastructure Configuration ──────────────────────────────────────────────

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = "${var.pipeline_name}-infra-config"
  description                   = "Infrastructure configuration for ${var.pipeline_name}."
  instance_profile_name         = aws_iam_instance_profile.image_builder.name
  instance_types                = [var.instance_type]
  terminate_instance_on_failure = true

  subnet_id          = local.build_subnet_id
  security_group_ids = concat(var.security_group_ids, [aws_security_group.image_builder.id])

  tags = var.default_tags
}

# ── Distribution Configuration ────────────────────────────────────────────────

resource "aws_imagebuilder_distribution_configuration" "this" {
  name        = "${var.pipeline_name}-distribution-config"
  description = "AMI distribution configuration for ${var.pipeline_name}."

  distribution {
    region = var.aws_region

    ami_distribution_configuration {
      # {{ imagebuilder:buildDate }} is resolved by Image Builder at runtime.
      name        = "${var.pipeline_name}-{{ imagebuilder:buildDate }}"
      description = "Golden AMI produced by the ${var.pipeline_name} pipeline."
      ami_tags    = var.default_tags
      kms_key_id  = aws_kms_key.image_builder.arn

      # Restrict AMI launch permission to the owning account only.
      launch_permission {
        user_ids = [data.aws_caller_identity.current.account_id]
      }
    }
  }

  tags = var.default_tags
}

# ── Image Pipeline ────────────────────────────────────────────────────────────

resource "aws_imagebuilder_image_pipeline" "this" {
  name = var.pipeline_name

  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn

  # Schedule block is injected ONLY when schedule_type = "SCHEDULE".
  # When schedule_type = "MANUAL", this block is omitted — the pipeline
  # will only run when explicitly triggered via the console or CLI.
  dynamic "schedule" {
    for_each = local.enable_schedule ? [1] : []
    content {
      schedule_expression                = var.schedule_expression
      pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
    }
  }

  image_tests_configuration {
    image_tests_enabled = false
  }

  image_scanning_configuration {
    image_scanning_enabled = false
  }

  tags = var.default_tags
}