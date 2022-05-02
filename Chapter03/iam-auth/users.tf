resource "aws_iam_policy" "eks_policy" {
  name = "eks_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user" "lakshmi" {
  name = "lakshmi"
}

resource "aws_iam_user_group_membership" "lakshmi" {
  user = aws_iam_user.lakshmi.name

  groups = [
    aws_iam_group.cluster_administrators.name,
  ]
}

resource "aws_iam_user_policy_attachment" "cluster_access" {
  user       = aws_iam_user.lakshmi.name
  policy_arn = aws_iam_policy.eks_policy.arn
}

// add users and attach them to groups for project x 

// kiran to project-x 

resource "aws_iam_user" "kiran" {
  name = "kiran"
}

resource "aws_iam_user_group_membership" "kiran" {
  user = aws_iam_user.kiran.name

  groups = [
    aws_iam_group.project_x.name,
  ]
}

// for users to configure kubeconfig via cli
resource "aws_iam_user_policy_attachment" "cluster_access_kiran" {
  user       = aws_iam_user.kiran.name
  policy_arn = aws_iam_policy.eks_policy.arn
}

// aditi to project-x
resource "aws_iam_user" "aditi" {
  name = "aditi"
}

resource "aws_iam_user_group_membership" "aditi" {
  user = aws_iam_user.aditi.name

  groups = [
    aws_iam_group.project_x.name,
  ]
}

resource "aws_iam_user_policy_attachment" "cluster_access_aditi" {
  user       = aws_iam_user.aditi.name
  policy_arn = aws_iam_policy.eks_policy.arn
}

// ... and project y