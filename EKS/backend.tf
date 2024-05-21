terraform {
  backend "s3" {
    bucket = "dina-eks-jenkins"
    key    = "EKS/terraform.tfstate"
    region = "us-east-2"
  }
}
