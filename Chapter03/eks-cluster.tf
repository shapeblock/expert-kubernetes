module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 2
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]

  map_roles = [
    {
      rolearn  = aws_iam_role.cluster_admin.arn
      username = "admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = aws_iam_role.project_x.arn
      username = "kiran"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]
  map_users = [
    {
      userarn  = aws_iam_user.aditi.arn
      username = "aditi"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
