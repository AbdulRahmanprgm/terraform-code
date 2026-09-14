terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0"
    }
  }
}

locals {
  lambda_architectures  = var.arm64_enabled ? ["arm64"] : ["x86_64"]
  kms_key_arn           = var.kms_enabled ? (var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.this[0].arn) : null
  lambda_role_arn       = var.create_role ? aws_iam_role.this[0].arn : null
  effective_source_path = var.source_path != "" ? var.source_path : "payload.zip"
}

# Create KMS Key when kms_enabled is true and no external kms_key_arn is given
resource "aws_kms_key" "this" {
  count                   = var.kms_enabled && var.kms_key_arn == "" ? 1 : 0
  description             = "KMS key for Lambda function ${var.function_name}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow CloudWatch Logs and Lambda KMS Access"
        Effect = "Allow"
        Principal = {
          Service = [
            "logs.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.default_tags
}

# CloudWatch Log Group for Lambda logs
resource "aws_cloudwatch_log_group" "this" {
  #checkov:skip=CKV_AWS_338:Retention of 14 days is appropriate for standard environment logs
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
  kms_key_id        = local.kms_key_arn
  tags              = var.default_tags
}

# IAM Role for Lambda function
resource "aws_iam_role" "this" {
  count       = var.create_role ? 1 : 0
  name        = "${var.function_name}-execution-role"
  description = "Execution role for Lambda function ${var.function_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.default_tags
}

# Least-privilege IAM Policy for CloudWatch Logging, KMS, and X-Ray
resource "aws_iam_policy" "this" {
  count       = var.create_role ? 1 : 0
  name        = "${var.function_name}-execution-policy"
  description = "Least privilege execution policy for Lambda function ${var.function_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "${aws_cloudwatch_log_group.this.arn}:*"
        },
        {
          Effect = "Allow"
          Action = [
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords"
          ]
          Resource = "*"
        }
      ],
      var.kms_enabled ? [
        {
          Effect = "Allow"
          Action = [
            "kms:Decrypt",
            "kms:GenerateDataKey*"
          ]
          Resource = local.kms_key_arn != null ? local.kms_key_arn : "*"
        }
      ] : []
    )
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

# Lambda Function resource
resource "aws_lambda_function" "this" {
  #checkov:skip=CKV_AWS_115:Function level concurrent execution limit is optional and not defined in required variables
  #checkov:skip=CKV_AWS_116:Dead Letter Queue is optional and not defined in required variables
  #checkov:skip=CKV_AWS_117:VPC configuration is optional and not defined in required variables
  #checkov:skip=CKV_AWS_272:Code signing is optional and not defined in required variables
  #checkov:skip=CKV_AWS_173:KMS key is configured via kms_key_arn parameter
  #ts:skip=AC_AWS_0486 Lambda function VPC configuration is optional

  function_name = var.function_name
  package_type  = var.package_type
  role          = local.lambda_role_arn
  architectures = local.lambda_architectures
  memory_size   = var.memory_size
  timeout       = var.timeout

  runtime   = var.package_type == "Zip" ? var.runtime : null
  handler   = var.package_type == "Zip" ? var.handler : null
  image_uri = var.package_type == "Image" ? var.image_uri : null

  filename         = var.package_type == "Zip" ? local.effective_source_path : null
  source_code_hash = var.package_type == "Zip" && fileexists(local.effective_source_path) ? filebase64sha256(local.effective_source_path) : null

  kms_key_arn = local.kms_key_arn

  tracing_config {
    mode = "Active"
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy_attachment.this
  ]

  tags = var.default_tags
}
