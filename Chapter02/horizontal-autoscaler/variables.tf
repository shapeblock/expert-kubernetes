variable "aws_region" {
  default     = "ap-south-1"
  description = "AWS Region to deploy infra to."
  type        = string
}

// Cluster stuff

variable "cluster_name" {
  default     = "aws-dev"
  description = "Name of the Kubernetes cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes cluster version, recommended to run latest provided by EKS."
  type        = string
}


variable "instance_type" {
  default     = "t2.medium"
  description = "The type of AWS instance to create."
  type        = string
}
