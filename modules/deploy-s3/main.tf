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
  s3_bucket         = "${var.bucket}"
  s3_key            = "${var.key}"
  function_name = var.name
  timeout = var.timeout
  memory_size = var.memory_size
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.main"
  runtime = "nodejs12.x"

  environment {
      variables = var.lambdavars
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
