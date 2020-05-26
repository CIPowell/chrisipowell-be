data "aws_iam_policy_document" "lamdba_execution_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "cloudwatch_permissions" {
    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]

        resources = ["*"]
    }
}

resource "aws_iam_role" "lambda_execution_role" {
   name = "lambda_execution_role"
   assume_role_policy = data.aws_iam_policy_document.lamdba_execution_policy.json
}

resource "aws_iam_policy" "cloudwatch_policy" {
    name = "cloudwatch_write"

    policy = data.aws_iam_policy_document.cloudwatch_permissions.json
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch" {
    role = aws_iam_role.lambda_execution_role.name
    policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

output "lambda_role_arn" {
    value = aws_iam_role.lambda_execution_role.arn
}