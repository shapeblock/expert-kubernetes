terraform {
  backend "s3" {
    bucket  = "production-grade-eks-ab84c7"
    key     = "tfstate"
    region  = "ap-south-1"
    profile = "sb"
  }
}
