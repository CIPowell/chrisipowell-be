resource "aws_apigatewayv2_api" "api" {
    name = "cipapi"
    protocol_type = "HTTP"
}

output "api_gateway_id" {
    value = aws_apigatewayv2_api.api.id
}