resource "helm_release" "cluster_autoscaler" {
  provider = helm.eks

  name       = "cluster-autoscaler"
  namespace  = "kube-system"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version = "9.29.0"

  depends_on = [
    null_resource.wait_for_eks,
    aws_eks_node_group.pitflow_nodes
  ]

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = aws_eks_cluster.pitflow_cluster.name
      }
      awsRegion = "us-east-1"
      rbac = {
        create = true
      }
      fullnameOverride = "cluster-autoscaler-pitflow"
      extraArgs = {
        balance-similar-node-groups  = true
        scale-down-unneeded-time     = "5m"
        v                            = 4
      }
    })
  ]

  wait    = true
  timeout = 600
}