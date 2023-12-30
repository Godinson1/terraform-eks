data "aws_availability_zones" "azs" {}

module "app-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = "${var.env_prefix}-vpc"
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets  = var.public_subnets_cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway  = true
  enable_dns_hostnames = true

  tags = {
   "kubernetes.io/cluster/${var.app_name}-cluster" = "shared"
  }

   private_subnet_tags = {
     "kubernetes.io/cluster/${var.app_name}-cluster" = "shared"
     "kubernetes.io/role/internal-elb" = 1
   }

   public_subnet_tags = {
    "kubernetes.io/cluster/${var.app_name}-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
   }
}