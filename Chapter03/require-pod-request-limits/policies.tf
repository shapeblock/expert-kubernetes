resource "kubectl_manifest" "require_pod_request_limits" {
  yaml_body  = file("${path.module}/require-pod-request-limits.yml")
}
