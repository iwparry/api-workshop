# IAM for Lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name               = "api-workshop-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_policy" {
  name = "api-workshop-lambda-policy"

  policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DynamoDBPermissions",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Scan"
      ],
      "Resource": "${aws_dynamodb_table.my_table.arn}"
    },
    {
      "Sid": "LogGroupPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup"
      ],
      "Resource": "arn:aws:logs:${var.region}:${var.account}:*"
    },
        {
      "Sid": "LogStreamPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${var.account}:*:*:*"
    }
  ]
  }
  EOF
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "api-workshop-lambda-policy-attachment"
  policy_arn = aws_iam_policy.lambda_policy.arn
  roles      = [aws_iam_role.iam_for_lambda.name]
}
