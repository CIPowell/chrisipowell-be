variable api_gateway_id {}
variable lambda_role_id {}

resource "aws_lambda_function" "status_function" {
    function_name = "status_function"
    handler = "src/main"
    role = var.lambda_role_id
    runtime = "nodejs12.x"
}

