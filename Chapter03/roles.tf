resource "aws_iam_role" "cluster_admin" {
  name        = "cluster-admin"
  description = "Cluster administrator role for EKS clusters."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Condition = {}
      },
    ]
  })
}

// developer for project x
resource "aws_iam_role" "project_x" {
  name        = "project-x"
  description = "Developers who have full access in project-x."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Condition = {}
      },
    ]
  })
}

// developer for project y
