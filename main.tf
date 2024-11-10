provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr_block = var.vpc_cidr_block
  tags = local.project_tags
  public_cidr_block = var.public_cidr_block
  private_cidr_block = var.private_cidr_block
  availability_zone = var.availabity_zone

}