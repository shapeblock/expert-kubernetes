resource "helm_release" "mysql" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  name       = "client-db-copy"
  namespace  = "maxbytes"
  timeout    = 600
  version    = "8.9.6"

  set {
    name  = "primary.persistence.existingClaim"
    value = "client-db-copy"
  }
  set {
    name  = "auth.rootPassword"
    value = "root123#"
  }
}
