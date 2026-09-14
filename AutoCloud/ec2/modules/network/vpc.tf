###############################################################################
# VPC
# AC_AWS_0113: Flow logging is enabled via aws_flow_log.this.
###############################################################################
data "aws_caller_identity" "current" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])
}

resource "aws_vpc" "this" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.instance_name}-vpc"
  })
}

# Restrict default SG — satisfies CKV2_AWS_12
resource "aws_default_security_group" "this" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  vpc_id = aws_vpc.this[each.key].id

  revoke_rules_on_delete = true

  ingress = []
  egress  = []

  tags = merge(var.tags, {
    Name = "${var.instance_name}-default-sg-restricted"
  })
}

###############################################################################
# KMS key for CloudWatch Log Group encryption
# Satisfies: CKV_AWS_158 "Ensure CloudWatch Log Group is encrypted by KMS"
###############################################################################
resource "aws_kms_key" "vpc_flow_log" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  description             = "KMS key for VPC flow log group encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${values(data.aws_caller_identity.current)[0].account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.instance_name}-vpc-flow-log-kms"
  })
}

resource "aws_kms_alias" "vpc_flow_log" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  name          = "alias/${var.instance_name}-vpc-flow-log"
  target_key_id = aws_kms_key.vpc_flow_log[each.key].key_id
}

###############################################################################
# VPC Flow Logs
# CKV2_AWS_11: aws_flow_log references the managed VPC directly.
# CKV_AWS_338: retention_in_days = 365 (≥ 1 year)
# CKV_AWS_158: kms_key_id set to the key created above
###############################################################################
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  name              = "/aws/vpc/flowlog/${var.instance_name}"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.vpc_flow_log[each.key].arn

  tags = merge(var.tags, {
    Name = "${var.instance_name}-vpc-flow-log-group"
  })
}

resource "aws_iam_role" "vpc_flow_log" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  name = "${var.instance_name}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, {
    Name = "${var.instance_name}-vpc-flow-log-role"
  })
}

resource "aws_iam_role_policy" "vpc_flow_log" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  name = "${var.instance_name}-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = aws_cloudwatch_log_group.vpc_flow_log[each.key].arn
    }]
  })
}

# Satisfies: CKV2_AWS_11 / AC_AWS_0113
resource "aws_flow_log" "this" {
  for_each = var.create_vpc ? toset(["this"]) : toset([])

  vpc_id               = aws_vpc.this[each.key].id
  traffic_type         = "ALL"
  iam_role_arn         = aws_iam_role.vpc_flow_log[each.key].arn
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log[each.key].arn
  log_destination_type = "cloud-watch-logs"

  tags = {
    Name             = "${var.instance_name}-vpc-flow-log"
    ParentResourceId = "aws_vpc.this"
  }
}
