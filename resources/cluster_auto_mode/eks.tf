module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.0"
  cluster_name                             = "${local.name}-automode"
  cluster_version                          = "1.31"
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  iam_role_additional_policies = {
    spot          = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
    SpotAutoscale = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetAutoscaleRole"
    # ec2Full       = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  }

  tags = local.tags
}

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}