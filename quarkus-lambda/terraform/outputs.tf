
output "aws_lambda_function" {
    value = aws_lambda_function.quarkus_lambda.arn
    description = "Quarkus Lambda ARN"
}
output "aws_lambda_function_url" {
    value = <<EOF
        Lambda URL: ${aws_lambda_function_url.quarkus_lambda_url.function_url}
        curl -X POST '${aws_lambda_function_url.quarkus_lambda_url.function_url}' \
             -H 'content-type: application/json' \
             -d '{ "body": "hello lambda" }'
    EOF
    description = "URL de la lambda"
}
