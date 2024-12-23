data "aws_eks_cluster" "selected" {
  name = "${local.name}-self-managed-nodes"
}

data "aws_eks_cluster_auth" "selected" {
  name = "${local.name}-self-managed-nodes"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.selected.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.selected.token
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
      mapRoles = yamlencode([
      {
        rolearn  = local.admin_role
        username = "admin"
        groups   = ["system:masters"]
      }
    ])
  }
}