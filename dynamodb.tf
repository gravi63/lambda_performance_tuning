resource "aws_dynamodb_table" "lambda_apigateway" {
  name         = "lambda-apigateway"
  billing_mode = "PAY_PER_REQUEST" # on-demand, no need to manage read/write capacity

  hash_key = "id"

  attribute {
    name = "id"
    type = "S" # string
  }
}
