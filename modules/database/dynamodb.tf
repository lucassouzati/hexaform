resource "aws_dynamodb_table" "hexafood_producao_table" {
  name           = "pedidos"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name = "pedidos"
  }
}