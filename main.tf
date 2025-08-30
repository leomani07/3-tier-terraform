provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source            = "./ec2"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  key_name          = "bharathi"
  ami_id            = "ami-0f58b397bc5c1f2e8" 
}


module "rds" {
  source            = "./rds"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  private_sg_id     = module.ec2.private_sg_id
  db_username       = "admin"
  db_password       = "Function!"
}



