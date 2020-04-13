resource "aws_apigatewayv2_api" "api" {
    name = "cipapi"
    protocol_type = "HTTP"
}

resource "aws_s3_bucket" "lambda_bucket" {
    bucket_prefix = "cip-lambda-code_"
    acl = "private"
}

output "api_gateway_id" {
    value = aws_apigatewayv2_api.api.id
}

output "lambda_bucket_arn" {
    value = aws_s3_bucket.lambda_bucket.id
}