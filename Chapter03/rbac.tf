resource "kubernetes_role" "developer" {
  metadata {
    name      = "developer"
    namespace = "project-x"
  }

  rule {
    api_groups = ["", "apps", "batch", "extensions"]
    resources = [
      "pods",
      "pods/attach",
      "pods/exec",
      "pods/log",
      "configmaps",
      "cronjobs",
      "deployments",
      "events",
      "ingresses",
      "jobs",
      "secrets",
      "services"
    ]
    verbs = ["create", "describe", "get", "list", "watch", "patch", "update", "delete"]
  }
}

resource "kubernetes_role_binding" "kiran" {
  metadata {
    name      = "developer"
    namespace = "project-x"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "developer"
  }
  subject {
    kind      = "User"
    name      = "kiran"
    api_group = "rbac.authorization.k8s.io"
  }
}
