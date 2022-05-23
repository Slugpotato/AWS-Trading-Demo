
data "aws_ssm_parameter" "key_id" {
  name = "alpaca_key_id"
}

data "aws_ssm_parameter" "secret_key" {
  name = "alpaca_secret_key"
}

data "aws_ssm_parameter" "api_version" {
  name = "alpaca_api_version"
}

data "aws_ssm_parameter" "base_url" {
  name = "alpaca_base_url"
}
