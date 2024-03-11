
resource "aws_s3_bucket" "lambda_bucket" {
    bucket = var.lambda_bucket
}

resource "aws_iam_role" "iam_for_lambda" {
    name               = "iam_for_lambda"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
    ]
}

resource "aws_lambda_function" "quarkus_lambda" {
    function_name    = var.lambda_function_name
    filename         = var.lambda_bucket
    source_code_hash = filebase64sha256("../target/function.zip")
    handler          = "not.used.in.provided.runtime"
    runtime          = "provided.al2023"
    role             = aws_iam_role.iam_for_lambda.arn
    memory_size      = 128
    timeout          = 15

    logging_config {
        log_format = "Text"
    }
    tracing_config {
        mode = "Active"
    }
}

resource "aws_cloudwatch_log_group" "example" {
    name              = "/aws/lambda/${var.lambda_function_name}"
    retention_in_days = 1
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
    statement {
        effect = "Allow"

        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]

        resources = ["arn:aws:logs:*:*:*"]
    }
}

resource "aws_iam_policy" "lambda_logging" {
    name        = "lambda_logging"
    path        = "/"
    description = "IAM policy for logging from a lambda"
    policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role       = aws_iam_role.iam_for_lambda.name
    policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function_url" "test_latest" {
    function_name      = aws_lambda_function.quarkus_lambda.function_name
    authorization_type = "NONE"
}
