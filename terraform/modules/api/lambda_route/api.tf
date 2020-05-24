resource "aws_apigatewayv2_route" "route" { 
    api_id = var.api_gateway_id
    route_key = var.path
}