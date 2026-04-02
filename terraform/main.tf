data "aws_secretsmanager_secret" "db_password" {
  name = "capstone/db-password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

locals {
  db_password = jsondecode(
    data.aws_secretsmanager_secret_version.db_password.secret_string
  )["password"]
}

module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
  db_password        = local.db_password

  aws_region = var.aws_region
}

provider "aws" {
  region = "eu-west-2"
}