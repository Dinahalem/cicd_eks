terraform {
  backend "s3" {
    bucket = "dina-eks-jenkins"
    key    = "eks/terraform.tfstate"
    region = "us-east-2"
  }
}
