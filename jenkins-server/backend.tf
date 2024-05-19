terraform {
  backend "s3" {
    bucket = "dina-eks-jenkins"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-2"
  }
}
