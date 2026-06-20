output "lambda_function_arns" {
  description = "ARN of each created Lambda function, keyed by function name"
  value       = { for k, fn in aws_lambda_function.this : k => fn.arn }
}

output "lambda_function_names" {
  description = "Names of all created Lambda functions"
  value       = keys(aws_lambda_function.this)
}

output "lambda_invoke_arns" {
  description = "Invoke ARN of each Lambda function, keyed by function name (useful for API Gateway integrations)"
  value       = { for k, fn in aws_lambda_function.this : k => fn.invoke_arn }
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.lambda_apigateway.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.lambda_apigateway.arn
}

output "api_invoke_url" {
  description = "Invoke URL for the dynamodbmanager resource on the Prod stage"
  value       = "${aws_api_gateway_stage.prod.invoke_url}/${aws_api_gateway_resource.dynamodb_manager.path_part}"
}
