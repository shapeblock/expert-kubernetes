data "aws_eks_cluster" "cluster" {
  name = "day-2-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "day-2-cluster"
}
