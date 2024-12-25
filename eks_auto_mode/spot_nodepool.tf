# Karpenter Node Pool for Spot Instances
## This resource creates an additional node pool for Spot Instances using Karpenter.
### For more information, refer to the AWS EKS Node Pool documentation. 
#### https://docs.aws.amazon.com/eks/latest/userguide/create-node-pool.html?icmpid=docs_console_unmapped 
##### https://karpenter.sh/docs/concepts/nodepools/

resource "kubernetes_manifest" "karpenter_nodepool" {
  manifest = {
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = "onspot-nodepool"
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
          taints = [
            {
              key    = "only-use-for-tech-talk"
              value  = "true"
              effect = "NoSchedule"
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
