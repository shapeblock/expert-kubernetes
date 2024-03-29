variable "aws_region" {
  default     = "ap-south-1"
  description = "AWS Region to deploy infra to."
  type        = string
}

variable "cluster_name" {
  default     = "aws-dev"
  description = "Name of the Kubernetes cluster."
  type        = string
}
