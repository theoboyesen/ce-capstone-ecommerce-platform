module "networking" {
  source = "./modules/networking"
}


module "compute" {
  source = "./modules/compute"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
  db_password        = var.db_password

  aws_region         = var.aws_region
}

provider "aws" {
  region = "eu-west-2"
}