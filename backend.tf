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
  handler = "lib/index.handler"
  path = "/blog"
  policies = [module.policies.cloudwatch_policy, aws_iam_policy.contentful_key_access.arn]
}

module "page" {
  source = "./terraform/modules/api/lambda_route"
  api_gateway_id = module.api_gateway.api_gateway_id
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
  method = "GET"
  name = "pages"
  handler = "lib/index.handler"
  path = "/page/{slug}"
  policies = [module.policies.cloudwatch_policy, aws_iam_policy.contentful_key_access.arn]
}