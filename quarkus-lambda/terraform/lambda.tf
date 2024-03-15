#
#

resource "aws_s3_bucket" "lambda_bucket" {
    bucket = var.lambda_bucket
}

resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
    bucket = aws_s3_bucket.lambda_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_object" "lambda" {
    bucket = var.lambda_bucket
    key    = "lambda"
    source = "../target/function.zip"
    etag   = filemd5("../target/function.zip")

    depends_on = [
        aws_s3_bucket.lambda_bucket
    ]
}

resource "aws_iam_role" "lambda_execution_role" {
    name                = "lambda_execution_role"
    assume_role_policy  = data.aws_iam_policy_document.assume_role.json
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
    ]
}

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


resource "aws_lambda_function" "quarkus_lambda" {
    function_name = var.lambda_function_name
    s3_bucket     = var.lambda_bucket
    s3_key        = "lambda"
    handler       = "not.used.in.provided.runtime"
    runtime       = "provided.al2023"
    role          = aws_iam_role.lambda_execution_role.arn
    memory_size   = 128
    timeout       = 15

    logging_config {
        log_format = "Text"
    }
    tracing_config {
        mode = "Active"
    }

    depends_on = [
        aws_s3_object.lambda,
        aws_iam_role_policy_attachment.lambda_logs_role,
        aws_cloudwatch_log_group.example,
    ]
}

resource "aws_cloudwatch_log_group" "example" {
    name              = "/aws/lambda/${var.lambda_function_name}-tf"
    retention_in_days = 1
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging_policy" {
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

resource "aws_iam_policy" "lambda_logging_policy" {
    name        = "lambda_logging"
    path        = "/"
    description = "IAM policy for logging from a lambda"
    policy      = data.aws_iam_policy_document.lambda_logging_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_role" {
    role       = aws_iam_role.lambda_execution_role.name
    policy_arn = aws_iam_policy.lambda_logging_policy.arn
}
