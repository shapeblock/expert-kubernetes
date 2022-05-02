resource "aws_eks_identity_provider_config" "example" {
  cluster_name = "education-eks-y5OrtiJx"

  oidc {
    client_id                     = "production-kubernetes"
    identity_provider_config_name = "dex-auth"
    issuer_url                    = "https://dex.prod-cluster.shapeblock.xyz"
    username_claim                = "email"
  }
}
