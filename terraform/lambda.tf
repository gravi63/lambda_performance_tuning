# Zips each .py file individually into its own deployment package
data "archive_file" "lambda_zip" {
  for_each = var.lambda_functions

  type        = "zip"
  source_file = "${var.lambda_source_dir}/${each.value.source_file}"
  output_path = "${path.module}/builds/${each.key}.zip"
}

resource "aws_lambda_function" "this" {
  for_each = var.lambda_functions

  function_name = each.key
  role          = aws_iam_role.test_lambda_role.arn
  handler       = each.value.handler
  runtime       = each.value.runtime
  timeout       = each.value.timeout
  memory_size   = each.value.memory_size

  filename         = data.archive_file.lambda_zip[each.key].output_path
  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256

  dynamic "environment" {
    for_each = length(each.value.environment) > 0 ? [each.value.environment] : []
    content {
      variables = environment.value
    }
  }
}
