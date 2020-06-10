provider "aws" {
    region  = var.region
}

data "archive_file" "init" {
  type        = "zip"
  source_dir  = var.src
  output_path = "${var.output_path}/${var.name}.zip"
  # excludes = [".terraform"]
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.name}_iam_policy_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from lambda ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.name}_iam_role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "this_lambda" {
  filename      = "${var.output_path}/${var.name}.zip"
  function_name = var.name
  timeout = var.timeout
  memory_size = var.memory_size
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.main"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("${var.output_path}/${var.name}.zip")

  runtime = "nodejs12.x"

  environment {
      variables = var.lambdavars
  }
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
