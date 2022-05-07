resource "kubernetes_namespace" "velero" {
  lifecycle {
    ignore_changes = [metadata]
  }

  metadata {
    name = "velero"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on       = [kubernetes_namespace.velero]
  destroy_duration = "30s"
}

resource "helm_release" "velero" {
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  name       = "velero"
  namespace  = "velero"
  timeout    = 600
  depends_on = [time_sleep.wait_30_seconds]
  version    = "2.29.4"

  set {
    name  = "credentials.secretContents.cloud"
    value = templatefile("${path.module}/credentials.tpl", { aws_access_key_id: aws_iam_access_key.velero.id, aws_secret_access_key: aws_iam_access_key.velero.secret })
  }
  set {
    name  = "configuration.provider"
    value = "aws"
  }
  set {
    name  = "configuration.backupStorageLocation.name"
    value = "aws"
  }
  set {
    name  = "configuration.backupStorageLocation.bucket"
    value = aws_s3_bucket.velero.id
  }
  set {
    name  = "configuration.backupStorageLocation.config.region"
    value = var.aws_region
  }
  set {
    name  = "configuration.volumeSnapshotLocation.name"
    value = "aws"
  }
  set {
    name  = "configuration.volumeSnapshotLocation.config.region"
    value = var.aws_region
  }
  set {
    name  = "initContainers[0].name"
    value = "velero-plugin-for-aws"
  }
  set {
    name  = "initContainers[0].image"
    value = "velero/velero-plugin-for-aws:v1.4.0"
  }
  set {
    name  = "initContainers[0].volumeMounts[0].mountPath"
    value = "/target"
  }
  set {
    name  = "initContainers[0].volumeMounts[0].name"
    value = "plugins"
  }
}
