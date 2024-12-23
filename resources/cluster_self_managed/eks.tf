module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "${local.name}-self-managed-nodes"
  cluster_version = "1.31"

  # EKS Addons
  cluster_addons = {
    coredns = {
      Version = "v1.11.3-eksbuild.1"
    }
    eks-pod-identity-agent = {}
    kube-proxy = {
      Version = "v1.31.2-eksbuild.3"
    }
    vpc-cni = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  iam_role_use_name_prefix = false

  self_managed_node_groups = {
    onDemand = {
      ami_type      = "BOTTLEROCKET_x86_64"
      instance_type = "t2.micro"
      min_size      = 1
      max_size      = 2
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size            = 1
      user_data_template_path = "${path.module}/templates/userdata.sh.tpl"
    }
  }

  tags = local.tags
}