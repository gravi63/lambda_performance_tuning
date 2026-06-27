resource "aws_apigatewayv2_authorizer" "auth0" {
  api_id           = aws_apigatewayv2_api.dynamodb_operations.id
  authorizer_type  = "JWT"
  name             = "auth0-jwt-authorizer"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    # Auth0 domain — replace with your actual domain
    issuer   = "https://dev-nspai7uahqa8gj5g.us.auth0.com/"
    # API Identifier you set in Auth0 dashboard
    audience = ["https://ddboperations.api"]
  }
}