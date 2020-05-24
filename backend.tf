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
  lambda_role_id = module.lambda_base.lambda_role_arn
  method = "GET"
  name = "statusCheck"
  handler = "handler"
  path = "/status"
}