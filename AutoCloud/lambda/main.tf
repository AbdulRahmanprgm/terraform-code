module "lambda" {
  source = "./modules/lambda"

  function_name = var.function_name
  package_type  = var.package_type
  runtime       = var.runtime
  handler       = var.handler
  source_path   = var.source_path
  image_uri     = var.image_uri

  create_role   = var.create_role
  arm64_enabled = var.arm64_enabled

  kms_enabled = var.kms_enabled
  kms_key_arn = var.kms_key_arn

  memory_size = var.memory_size
  timeout     = var.timeout

  default_tags = var.default_tags
}
