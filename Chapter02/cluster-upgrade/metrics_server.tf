
resource "helm_release" "metrics" {
  name            = "metrics-server"
  chart           = "metrics-server"
  repository      = "https://charts.helm.sh/stable"
  namespace       = "kube-system"
  cleanup_on_fail = true

  dynamic "set" {
    for_each = {
      "args[0]" = "--kubelet-preferred-address-types=InternalIP"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}