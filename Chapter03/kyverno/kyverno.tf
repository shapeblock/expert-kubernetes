resource "kubernetes_namespace" "kyverno" {
  lifecycle {
    ignore_changes = [metadata]
  }

  metadata {
    name = "kyverno"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on       = [kubernetes_namespace.kyverno]
  destroy_duration = "30s"
}

resource "helm_release" "kyverno" {
  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  name       = "kyverno"
  namespace  = "kyverno"
  timeout    = 600
  depends_on = [time_sleep.wait_30_seconds]

  set {
    name  = "replicaCount"
    value = 3
  }

}