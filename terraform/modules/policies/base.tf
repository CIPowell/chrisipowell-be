resource "aws_iam_policy" "cloudwatch_policy" {
    name = "cloudwatch_write"

    policy = data.aws_iam_policy_document.cloudwatch_permissions.json
}

data "aws_iam_policy_document" "cloudwatch_permissions" {
    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "xray:*"
        ]

        resources = ["*"]
    }
}

output "cloudwatch_policy" {
    value = aws_iam_policy.cloudwatch_policy.arn
}