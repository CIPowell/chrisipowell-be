provider "aws" {
  region = "eu-west-1"
}

module "lambda_base" {
  source = "./terraform/modules/roles"
}

module "api_gateway" {
  source = "./terraform/modules/api/base"
}

module "status_lambda" {
  source = "./terraform/modules/api/lambda_route"
  api_gateway_id = module.api_gateway.api_gateway_id
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
  lambda_role_id = module.lambda_base.lambda_role_arn
  method = "GET"
  name = "statusCheck"
  handler = "src/index.handler"
  path = "/status"
}

module "blog_list" {
  source = "./terraform/modules/api/lambda_route"
  api_gateway_id = module.api_gateway.api_gateway_id
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
  lambda_role_id = module.lambda_base.lambda_role_arn
  method = "GET"
  name = "listPosts"
  handler = "src/index.handler"
  path = "/blog"
}