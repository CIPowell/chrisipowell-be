data "aws_iam_policy_document" "lamdba_execution_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "lambda_execution_role" {
   name = "lambda_execution_role"
   assume_role_policy = data.aws_iam_policy_document.lamdba_execution_policy.json
}
