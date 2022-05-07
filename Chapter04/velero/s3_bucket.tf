resource "aws_s3_bucket" "velero" {
  bucket_prefix = "velero-"

  tags = {
    Name        = "Expert Kubernetes"
    Environment = "Develop"
  }
}

resource "aws_s3_bucket_acl" "velero_bucket_acl" {
  bucket = aws_s3_bucket.velero.id
  acl    = "private"
}

