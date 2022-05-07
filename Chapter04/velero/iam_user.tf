resource "aws_iam_user" "velero" {
  name = "velero"
}

resource "aws_iam_access_key" "velero" {
  user = aws_iam_user.velero.name
}
