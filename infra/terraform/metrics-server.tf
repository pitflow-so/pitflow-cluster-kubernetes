resource "helm_release" "metrics_server" {
  provider = helm.eks

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  namespace = "kube-system"

  values = [
    yamlencode({
      args = [
        "--kubelet-insecure-tls"
      ]
    })
  ]

  depends_on = [
    aws_eks_node_group.pitflow_nodes
  ]
}