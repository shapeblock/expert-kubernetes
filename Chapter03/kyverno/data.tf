data "aws_eks_cluster" "cluster" {
  name = "education-eks-y5OrtiJx"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "education-eks-y5OrtiJx"
}
