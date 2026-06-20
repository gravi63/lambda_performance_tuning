# Trust policy: allows the Lambda service to assume this role
data "aws_iam_policy_document" "test_lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test_lambda_role" {
  name               = "test-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.test_lambda_assume_role.json
}

# Permissions policy: DynamoDB CRUD + CloudWatch Logs
data "aws_iam_policy_document" "test_lambda_policy" {
  statement {
    sid    = "Stmt1428341300017"
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "test_lambda_policy" {
  name   = "test-lambda-policy"
  role   = aws_iam_role.test_lambda_role.id
  policy = data.aws_iam_policy_document.test_lambda_policy.json
}
