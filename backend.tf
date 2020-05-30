provider "aws" {
  region = "eu-west-1"
}

module "api_gateway" {
  source = "./terraform/modules/api/base"
}

resource "aws_secretsmanager_secret" "contentful" {
  name = "contentful-api-key"
}

data "aws_iam_policy_document" "contentful_key_access" {
    statement {
        actions = [
            "secretsmanager:GetSecretValue"
        ]

        resources = [aws_secretsmanager_secret.contentful.arn]
    }
}

resource "aws_iam_policy" "contentful_key_access" {
  name = "contentful_key_access"
  policy = data.aws_iam_policy_document.contentful_key_access.json
}

module "policies" {
  source = "./terraform/modules/policies"
}

module "status_lambda" {
  source = "./terraform/modules/api/lambda_route"
  api_gateway_id = module.api_gateway.api_gateway_id
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
  method = "GET"
  name = "statusCheck"
  handler = "src/index.handler"
  path = "/status"
  policies = [module.policies.cloudwatch_policy]
}

module "blog_list" {
  source = "./terraform/modules/api/lambda_route"
  api_gateway_id = module.api_gateway.api_gateway_id
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
  method = "GET"
  name = "listPosts"
  handler = "src/index.handler"
  path = "/blog"
  policies = [module.policies.cloudwatch_policy, aws_iam_policy.contentful_key_access.arn]
}

resource "aws_iam_role_policy_attachment" "contentful_key_access" {
  role = module.blog_list.lambda_role_arn
  policy_arn = aws_iam_policy.contentful_key_access.arn
}