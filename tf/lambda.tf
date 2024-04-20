# Create a Lambda function

# Lambda function
resource "aws_lambda_function" "my_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda.output_path
  function_name = "api-workshop-function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs20.x"
}

# Permission for API Gateway to Invoke the Lambda Function
resource "aws_lambda_permission" "api" {
  statement_id = "AllowExecutionFromAPI"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.my_api.execution_arn}/*/*"
}