locals {
  ebs_block_device = {
    block_device_name = "/dev/sdc",
    volume_type       = "gp2"
    volume_size       = "20"
  }

  database_block_device = {
    block_device_name = "/dev/sdc",
    volume_type       = "gp2"
    volume_size       = "100"
  }
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets
  enable_irsa     = true
  vpc_id          = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  tags = {
    Environment = "develop"
    Project     = "expert-kubernetes"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = var.instance_type
      asg_min_size                  = 1
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      additional_security_group_ids = [aws_security_group.worker_group_1.id]
      additional_ebs_volumes        = [local.ebs_block_device]
      ami_id                        = "ami-01dd164a4205e1ba4"
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "owned"
        }
      ]
    },
    {
      name                          = "analytics-db"
      instance_type                 = "m5.large"
      asg_min_size                  = 1
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      additional_ebs_volumes        = [local.database_block_device]
      ami_id                        = "ami-01dd164a4205e1ba4"
      kubelet_extra_args = "--node-labels=footel.com/role=analytics-db"
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}
