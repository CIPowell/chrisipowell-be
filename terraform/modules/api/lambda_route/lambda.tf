data "archive_file" "temporary_lambda" {
    type = "zip"
    output_path = "${path.module}/lambda_function_payload.zip"

    source {
        content = "module.exports = (event, context) => ({ status: 'NOT IMPLEMENTED' });"
        filename = "src/index.js"
    }
}

resource "aws_lambda_function" "function" {
    function_name   = var.name
    handler         = var.handler
    role            = var.lambda_role_id
    runtime         = var.runtime

    filename        = data.archive_file.temporary_lambda.output_path
}

