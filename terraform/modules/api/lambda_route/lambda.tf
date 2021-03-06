data "archive_file" "temporary_lambda" {
    type = "zip"
    output_path = "${path.module}/lambda_function_payload.zip"

    source {
        content = "module.exports.handler = async(event, context) => ({ statusCode:200, body: 'NOT IMPLEMENTED', headers:{} });"
        filename = "src/index.js"
    }
}

resource "aws_lambda_function" "function" {
    function_name   = var.name
    handler         = var.handler
    role            = aws_iam_role.lambda_execution_role.arn
    runtime         = var.runtime
    
    filename        = data.archive_file.temporary_lambda.output_path

    tracing_config {
        mode = "Active"
    }
}

resource "aws_lambda_permission" "apigateway" {
    statement_id = "${var.name}AllowAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = var.name
    principal = "apigateway.amazonaws.com"
    source_arn = "${var.api_gateway_execution_arn}/*/*${var.path}"
}

resource "aws_lambda_alias" "dev" { 
   name = "dev"
   description = "Pre production alias"
   function_name = var.name
   function_version = "$LATEST"
}

resource "aws_lambda_alias" "prod" { 
   name = "prod"
   description = "production alias"
   function_name = var.name
   function_version = "$LATEST"

   lifecycle {
       ignore_changes = [
           function_version
       ]
   }
}

resource "aws_lambda_permission" "apigateway_dev" {
    statement_id = "AllowAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.function.arn
    principal = "apigateway.amazonaws.com"
    qualifier = "dev"
    source_arn = "${var.api_gateway_execution_arn}/*/*${var.path}"
}

resource "aws_lambda_permission" "apigateway_prod" {
    statement_id = "AllowAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.function.arn
    principal = "apigateway.amazonaws.com"
    qualifier = "prod"
    source_arn = "${var.api_gateway_execution_arn}/*/*${var.path}"
}