provider "aws" {
  region = "eu-west-1"
}

module "lambda_base" {
  source = "./terraform/modules/roles"
}

module "api_gateway" {
  source = "./terraform/modules/api/gateway"
}