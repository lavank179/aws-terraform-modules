data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "lavan-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "lambda.js"
#   output_path = "lambda_function_payload.zip"
# }

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "app.zip"
  function_name    = local.common_tags.environment
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "src/lambda.lambda_handler"
  publish          = true
  timeout          = 60
  source_code_hash = filebase64sha256("app.zip")

  # source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_alias" "lavan-blue-green" {
  name          = "live"
  function_name = aws_lambda_function.test_lambda.function_name
  depends_on    = [aws_lambda_function.test_lambda]

  # This should be the older stable version — hardcoded or via external source
  function_version = aws_lambda_function.test_lambda.version - 1

  routing_config {
    additional_version_weights = {
        "${aws_lambda_function.test_lambda.version}" = 0.5  # initially 0%
    }
  }
}