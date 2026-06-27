locals {
  api_methods = {
    POST   = "DDBCreateRecord"
    PUT    = "DDBUpdateRecord"
    DELETE = "DDBDeleteRecord"
    GET    = "DDBListRecords"
  }
}

# ── API ────────────────────────────────────────────────────────────────────────
resource "aws_apigatewayv2_api" "dynamodb_operations" {
  name          = "DDBOperations"
  protocol_type = "HTTP"
}

# ── Stage (auto-deploy removes the need for aws_apigatewayv2_deployment) ───────
resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.dynamodb_operations.id
  name        = "Prod"
  auto_deploy = true
}

# ── Integrations (one per Lambda) ─────────────────────────────────────────────
# HTTP API only supports AWS_PROXY; request/response mapping templates are not available.
# Lambda receives the standard payload format 2.0 event automatically.
resource "aws_apigatewayv2_integration" "this" {
  for_each = local.api_methods

  api_id                 = aws_apigatewayv2_api.dynamodb_operations.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.this[each.value].invoke_arn
  integration_method     = "POST"           # Lambda is always invoked via POST internally
  payload_format_version = "2.0"
}

# ── Routes (METHOD /ddbmanager → integration) ──────────────────────────────────
resource "aws_apigatewayv2_route" "this" {
  for_each = local.api_methods

  api_id    = aws_apigatewayv2_api.dynamodb_operations.id
  route_key = "${each.key} /ddbmanager"
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
  # Add these two lines
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.auth0.id
}

# ── Lambda permissions ─────────────────────────────────────────────────────────
resource "aws_lambda_permission" "apigw_invoke" {
  for_each = local.api_methods

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[each.value].function_name
  principal     = "apigateway.amazonaws.com"
  # HTTP API execution ARN pattern: arn:aws:execute-api:region:account:api-id/stage/method/route
  source_arn    = "${aws_apigatewayv2_api.dynamodb_operations.execution_arn}/*/*/ddbmanager"
}
