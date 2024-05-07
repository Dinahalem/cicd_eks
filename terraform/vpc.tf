provider "aws" {
  region = var.aws_region
  access_key = "AKIA6GBMEYMUE2PHTPC6"
  secret_key = "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"
}

data "aws_availability_zones" "available" {}


locals {
  cluster1_name = "primary-cluster"
  #cluster2_name = "secondary-cluster"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc_cluster" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "eks-vpc"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster1_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster1_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster1_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

