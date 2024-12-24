data "aws_eks_cluster_auth" "selected" {
  name       = format("%s-%s", local.name, "automode")
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.selected.token
}
