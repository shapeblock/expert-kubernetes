resource "kubectl_manifest" "restrict_registries" {
  yaml_body  = file("${path.module}/restrict-registries.yml")
}
