region = "us-east-1"

function_name = "my-lambda"

package_type = "Zip"

runtime     = "nodejs24.x"
handler     = "lambda_function.lambda_handler"
source_path = "payload.zip"

image_uri = ""

create_role = true

arm64_enabled = false

kms_enabled = false
kms_key_arn = ""

memory_size = 128
timeout     = 3

default_tags = {
  ManagedBy   = "MyTeam"
  Environment = "Dev"
  Project     = "trim-cistern-492506-c4"
}
