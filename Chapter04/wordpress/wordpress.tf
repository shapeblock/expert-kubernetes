resource "kubernetes_namespace" "wordpress" {
  lifecycle {
    ignore_changes = [metadata]
  }

  metadata {
    name = "wordpress"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on       = [kubernetes_namespace.wordpress]
  destroy_duration = "30s"
}

resource "helm_release" "wordpress" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  name       = "acme-wordpress"
  namespace  = "wordpress"
  timeout    = 600
  depends_on = [time_sleep.wait_30_seconds]
  version    = "14.0.4"

  set {
    name  = "wordpressUsername"
    value = "admin"
  }
  set {
    name  = "wordpressPassword"
    value = "password"
  }
  set {
    name  = "mariadb.auth.rootPassword"
    value = "secretpassword"
  }
  set {
    name  = "persistence.storageClass"
    value = "openebs-rwx"
  }
  set {
    name  = "persistence.accessModes"
    value = "{ReadWriteMany}"
  }
  set {
    name  = "mariadb.primary.persistence.storageClass"
    value = "cstor-csi-disk"
  }
  set {
    name  = "volumePermissions.enabled"
    value = true
  }
}
