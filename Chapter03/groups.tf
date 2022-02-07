resource "aws_iam_group_policy" "cluster_admin_policy" {
  name  = "cluster-admin-policy"
  group = aws_iam_group.cluster_administrators.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowAssumeOrganizationAccountRole"
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_group.cluster_administrators.name}"
      },
    ]
  })
}

resource "aws_iam_group" "cluster_administrators" {
  name = "cluster-administrators"
}


// group for project x
resource "aws_iam_group_policy" "project_x_policy" {
  name  = "project-x-policy"
  group = aws_iam_group.project_x.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowAssumeOrganizationAccountRole"
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_group.project_x.name}"
      },
    ]
  })
}

resource "aws_iam_group" "project_x" {
  name = "project-x"
}

// group for project y