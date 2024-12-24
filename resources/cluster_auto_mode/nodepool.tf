data "aws_eks_cluster" "selected" {
  name = "${local.name}-automode"
}

data "aws_eks_cluster_auth" "selected" {
  name = "${local.name}-automode"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.selected.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.selected.token
}

# Service-Linked Role for Spot Instances
## This service-linked role is required to utilize Spot Instances in the account.
### For more information, see the AWS documentation on Service-Linked Roles.
#### https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create-service-linked-role.html
resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}

# Karpenter Node Pool for Spot Instances
## This resource creates an additional node pool for Spot Instances using Karpenter.
### For more information, refer to the AWS EKS Node Pool documentation. 
#### https://docs.aws.amazon.com/eks/latest/userguide/create-node-pool.html?icmpid=docs_console_unmapped 

resource "kubernetes_manifest" "karpenter_nodepool" {
  manifest = {
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = "karpenter-onspot-nodepool"
    }
    spec = {
      template = {
        metadata = {
          labels = {
            ownedby = "tech-talk"
          }
        }
        spec = {
          nodeClassRef = {
            group = "eks.amazonaws.com"
            kind  = "NodeClass"
            name  = "default"
          }
          requirements = [
            {
              key      = "node.kubernetes.io/instance-type"
              operator = "In"
              values   = ["t3a.large", "t3a.xlarge"]
            },
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = ["spot"]
            }
          ]
        }
      }
      limits = {
        cpu    = "100"
        memory = "1000Gi"
      }
    }
  }
}
