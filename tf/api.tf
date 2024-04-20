# Create HTTP API
resource "aws_apigatewayv2_api" "my_api" {
  name          = "crud-workshop-api"
  protocol_type = "HTTP"
}

# Create routes
resource "aws_apigatewayv2_route" "get_items" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "put_items" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "get_items_id" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  depends_on = [
    aws_apigatewayv2_route.get_items,
    aws_apigatewayv2_route.put_items
  ]
}

resource "aws_apigatewayv2_route" "delete_items" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Create an integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.my_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.my_lambda.invoke_arn
  payload_format_version = "2.0"
}

# Create a stage for my API
resource "aws_apigatewayv2_stage" "my_api_stage" {
  api_id      = aws_apigatewayv2_api.my_api.id
  name        = "crud-workshop-api-stage"
  auto_deploy = true
}
