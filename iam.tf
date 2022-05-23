
resource "aws_iam_role" "trading_lambda_iam_role" {
  name               = "trading_lambda_iam_role"
  assume_role_policy = data.aws_iam_policy_document.trading_lambda_iam_role_policy_doc.json
}

# Trust Policy
data "aws_iam_policy_document" "trading_lambda_iam_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "trading_lambda_iam_role_policy" {
  name   = "lambda_iam_role_policy"
  role   = aws_iam_role.trading_lambda_iam_role.id
  policy = data.aws_iam_policy_document.lambda_exec_role_policy_doc.json
}

# Permission Policy
data "aws_iam_policy_document" "lambda_exec_role_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}
