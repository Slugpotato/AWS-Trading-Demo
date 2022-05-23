
provider "aws" {
  region = var.region
}

resource "aws_lambda_function" "trading_lambda" {
  filename         = "./builds/trading_lambda.zip"
  function_name    = "trading-lambda-function"
  source_code_hash = data.archive_file.trading_lambda.output_base64sha256
  role             = aws_iam_role.trading_lambda_iam_role.arn
  handler          = "trading_lambda.handler"
  runtime          = "python3.7"
  memory_size      = 2048
  timeout          = 900
  layers           = ["${aws_lambda_layer_version.pandas_layer.arn}"]

  environment {
    variables = {
      region      = var.region
      key_id      = data.aws_ssm_parameter.key_id.value
      secret_key  = data.aws_ssm_parameter.secret_key.value
      api_version = data.aws_ssm_parameter.api_version.value
      base_url    = data.aws_ssm_parameter.base_url.value
    }
  }
}

resource "null_resource" "lambda_buildstep" {
  triggers = {
    handler      = base64sha256(file("./trading_lambda.py"))
    requirements = base64sha256(file("./requirements.txt"))
    build        = base64sha256(file("./build.sh"))
  }

  provisioner "local-exec" {
    command = "./build.sh"

    environment = {
      lambda_file = "trading_lambda.py"
      dir_name    = "trading_lambda_package"
      runtime     = "python3.7"
    }
  }
}

data "archive_file" "trading_lambda" {
  depends_on  = [null_resource.lambda_buildstep]
  type        = "zip"
  source_dir  = "./trading_lambda_package"
  output_path = "./builds/trading_lambda.zip"
}

resource "aws_lambda_layer_version" "pandas_layer" {
  filename            = "./awswrangler-layer-1.10.0-py3.7.zip"
  layer_name          = "pandas_layer"
  compatible_runtimes = ["python3.7"]
}

#################
# Cloudwatch
#################

# resource "aws_cloudwatch_event_rule" "trading_lambda_rule" {
#   name        = "scheduled-lambda-rule"
#   description = "Fires every ten minutes on Weekdays between 7am to 12:55pm EST"
#   # schedule_expression = "cron(0/10 12-18 ? * MON-FRI *)"

#   # For testing 
#   schedule_expression = "rate(5 minutes)"
# }

# resource "aws_cloudwatch_event_target" "trading_lambda_target" {
#   rule      = aws_cloudwatch_event_rule.trading_lambda_rule.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.trading_lambda.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.trading_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.trading_lambda_rule.arn
# }

# resource "aws_cloudwatch_log_group" "log_group" {
#   name              = "/aws/lambda/${aws_lambda_function.trading_lambda.function_name}"
#   retention_in_days = 14
# }
