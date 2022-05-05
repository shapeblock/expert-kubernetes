resource "kubernetes_namespace" "maxbytes" {
  lifecycle {
    ignore_changes = [metadata]
  }

  metadata {
    name = "maxbytes"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on       = [kubernetes_namespace.maxbytes]
  destroy_duration = "30s"
}

resource "helm_release" "mysql" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  name       = "client-db"
  namespace  = "maxbytes"
  timeout    = 600
  depends_on = [time_sleep.wait_30_seconds]
  version    = "8.9.6"

  set {
    name  = "primary.persistence.storageClass"
    value = "cstor-csi-disk"
  }
  set {
    name  = "primary.persistence.size"
    value = "2Gi"
  }
  set {
    name  = "volumePermissions.enabled"
    value = true
  }
  set {
    name  = "auth.rootPassword"
    value = "root123#"
  }
}
