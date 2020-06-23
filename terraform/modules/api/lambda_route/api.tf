resource "aws_apigatewayv2_route" "route" { 
    api_id = var.api_gateway_id
    route_key = "${var.method} ${var.path}"    

    target = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_integration" "integration" { 
    api_id = var.api_gateway_id
    integration_type = "AWS_PROXY"

    integration_method = "GET"
    integration_uri = "${aws_lambda_function.function.arn}:$${stageVariables.name}"

    payload_format_version = "2.0"
}