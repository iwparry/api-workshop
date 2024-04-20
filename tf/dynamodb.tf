# Create a DynamoDB table
resource "aws_dynamodb_table" "my_table" {
  name           = "api-workshop-items"
  hash_key       = "id"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "id"
    type = "S"
  }
}
