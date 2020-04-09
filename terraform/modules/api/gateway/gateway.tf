resource "aws_apigatewayv2_api" "api" {
    name = "cipapi"
    protocol_type = "HTTP"
}