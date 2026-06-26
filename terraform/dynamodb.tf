resource "aws_dynamodb_table" "ddb_table" {
  name         = "ddb_table"
  billing_mode = "PAY_PER_REQUEST" # on-demand, no need to manage read/write capacity

  hash_key = "id"

  attribute {
    name = "id"
    type = "S" # string
  }
}
