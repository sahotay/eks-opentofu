module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.0"
  cluster_name                             = format("%s-%s", local.name, "automode")
  cluster_version                          = "1.31"
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = local.tags
}