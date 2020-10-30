data "aws_iam_policy_document" "lamdba_execution_policy" {
    statement {
        actions = [
            "sts:AssumeRole",
        ]
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }

    statement {
        actions = [
            "xray:*"
        ]
        resources = ["*"]
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "lambda_execution_role" {
   name = "${var.name}-execution-role"
   assume_role_policy = data.aws_iam_policy_document.lamdba_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
    count = length(var.policies)

    role = aws_iam_role.lambda_execution_role.name
    policy_arn = var.policies[count.index]
}

output "lambda_role_arn" {
    value = aws_iam_role.lambda_execution_role.arn
}