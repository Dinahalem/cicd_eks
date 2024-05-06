provider "aws" {
  region = local.region
}


locals {
  primary_name   = "primary-cluster"
  primary_region = "us-east-1"

  primary_vpc_cidr = "10.123.0.0/16"
  primary_azs      = ["us-east-1a", "us-east-1b"]

  primary_public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
  primary_private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  primary_intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]

  primary_tags = {
    Example = local.primary_name
  }

  secondary_name   = "secondary-cluster"
  secondary_region = "us-east-1"

  secondary_vpc_cidr = "10.124.0.0/16"
  secondary_azs      = ["us-east-1a", "us-east-1b"]

  secondary_public_subnets  = ["10.124.1.0/24", "10.124.2.0/24"]
  secondary_private_subnets = ["10.124.3.0/24", "10.124.4.0/24"]
  secondary_intra_subnets   = ["10.124.5.0/24", "10.124.6.0/24"]

  secondary_tags = {
    Example = local.secondary_name
  }
}

module "primary_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.primary_name
  cidr = local.primary_vpc_cidr

  azs             = local.primary_azs
  private_subnets = local.primary_private_subnets
  public_subnets  = local.primary_public_subnets
  intra_subnets   = local.primary_intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "primary_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name                   = local.primary_name
  cluster_endpoint_public_access = true

  # Other configurations for primary EKS cluster...

  tags = local.primary_tags
}

module "secondary_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.secondary_name
  cidr = local.secondary_vpc_cidr

  azs             = local.secondary_azs
  private_subnets = local.secondary_private_subnets
  public_subnets  = local.secondary_public_subnets
  intra_subnets   = local.secondary_intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "secondary_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name                   = local.secondary_name
  cluster_endpoint_public_access = true

  # Other configurations for secondary EKS cluster...

  tags = local.secondary_tags
}
