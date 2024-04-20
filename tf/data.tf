# Lambda IAM policy document
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Lambda code
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./files/index.mjs"
  output_path = "./files/index.zip"
}