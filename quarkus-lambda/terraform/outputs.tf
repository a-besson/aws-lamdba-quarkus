
output "aws_lambda_function" {
    value = aws_lambda_function.quarkus_lambda.arn
    description = "Quarkus Lambda ARN"
}
output "aws_lambda_function_url" {
    value = aws_lambda_function_url.quarkus_lambda_url.function_url
    description = "Lambda URL"
}
