resource "aws_iam_access_key" "lakshmi" {
  user = aws_iam_user.lakshmi.name
}

resource "aws_iam_access_key" "kiran" {
  user = aws_iam_user.kiran.name
}

resource "aws_iam_access_key" "aditi" {
  user = aws_iam_user.aditi.name
}