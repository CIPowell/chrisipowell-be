provider "aws" {
  region = "eu-west-1"
}

module "lambda_base" {
  source = "./terraform/modules/roles"
}

