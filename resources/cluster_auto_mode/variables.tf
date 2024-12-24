locals {
  name     = "eks-cluster"
  region   = "us-east-2"
  vpc_cidr = "10.0.64.0/18"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  tags = {
    cluster  = local.name
    createby = "terraform"
    ownedby  = "Tech Talk"
  }
}

variable "admin_role" {
  description = "Admin IAM role to create EKS cluster"
}