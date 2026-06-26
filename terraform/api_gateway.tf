# Maps each HTTP method to the Lambda function (key in aws_lambda_function.this) it integrates with
locals {
  api_methods = {
    POST   = "DDBCreateRecord"
    PUT    = "DDBUpdateRecord"
    DELETE = "DDBDeleteRecord"
    GET    = "DDBListRecords"
  }
}

resource "aws_api_gateway_rest_api" "dynamodb_operations" {
  name = "DDBOperations"
}

resource "aws_api_gateway_resource" "dynamodb_manager" {
  rest_api_id = aws_api_gateway_rest_api.dynamodb_operations.id
  parent_id   = aws_api_gateway_rest_api.dynamodb_operations.root_resource_id
  path_part   = "ddbmanager"
}

resource "aws_api_gateway_method" "this" {
  for_each = local.api_methods

  rest_api_id   = aws_api_gateway_rest_api.dynamodb_operations.id
  resource_id   = aws_api_gateway_resource.dynamodb_manager.id
  http_method   = each.key
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  for_each = local.api_methods

  rest_api_id             = aws_api_gateway_rest_api.dynamodb_operations.id
  resource_id             = aws_api_gateway_resource.dynamodb_manager.id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = "POST" # Lambda is always invoked via POST internally
  type                    = each.key == "GET" ? "AWS_PROXY" : "AWS"  # Non-proxy: request/response mapping applied
  uri                     = aws_lambda_function.this[each.value].invoke_arn
  content_handling        = each.key == "GET" ? "CONVERT_TO_TEXT" : null

  # Parse the JSON request body into a dict so Lambda receives event['tableName'] etc.
  request_templates = {
    "application/json" = "$input.json('$')"
  }
}

# Tell API Gateway to pass the Lambda's JSON return value out as the HTTP response body
resource "aws_api_gateway_method_response" "ok" {
  for_each = local.api_methods

  rest_api_id = aws_api_gateway_rest_api.dynamodb_operations.id
  resource_id = aws_api_gateway_resource.dynamodb_manager.id
  http_method = aws_api_gateway_method.this[each.key].http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "ok" {
  for_each = local.api_methods

  rest_api_id = aws_api_gateway_rest_api.dynamodb_operations.id
  resource_id = aws_api_gateway_resource.dynamodb_manager.id
  http_method = aws_api_gateway_method.this[each.key].http_method
  status_code = aws_api_gateway_method_response.ok[each.key].status_code

  # Pass the Lambda return value as-is to the response body
  response_templates = each.key == "GET" ? {"application/json" = ""} : {"application/json" = "$input.body"}

  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_method_response.ok,
  ]
}

resource "aws_lambda_permission" "apigw_invoke" {
  for_each = local.api_methods

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[each.value].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.dynamodb_operations.execution_arn}/*/${each.key}/${aws_api_gateway_resource.dynamodb_manager.path_part}"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.dynamodb_operations.id

  # Redeploy whenever the integration or response chain changes
  triggers = {
    redeployment = sha1(jsonencode({
      resource              = aws_api_gateway_resource.dynamodb_manager.id
      methods               = [for m in aws_api_gateway_method.this : m.id]
      integrations          = [for i in aws_api_gateway_integration.this : i.id]
      integration_responses = [for r in aws_api_gateway_integration_response.ok : r.id]
    }))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_integration_response.ok,
  ]
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.dynamodb_operations.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = "Prod"
}
