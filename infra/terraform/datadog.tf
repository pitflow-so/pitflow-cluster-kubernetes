# 1. Criação do Namespace
resource "kubernetes_namespace" "datadog" {
  metadata {
    name = "datadog"
  }
}

# 2. Criação do Secret com a API Key
resource "kubernetes_secret" "datadog_secret" {
  metadata {
    name      = "datadog-secret"
    namespace = kubernetes_namespace.datadog.metadata[0].name
  }

  data = {
    "api-key" = local.datadog_api_key
  }

  type = "Opaque"
}

# 3. Instalação do Datadog Operator via Helm
resource "helm_release" "datadog_operator" {
  provider = helm.eks

  name       = "datadog-operator"
  namespace  = kubernetes_namespace.datadog.metadata[0].name
  repository = "https://helm.datadoghq.com"
  chart      = "datadog-operator"

  # É uma boa prática fixar a versão para evitar que atualizações quebrem seu cluster
  version = "1.6.0"

  depends_on = [
    kubernetes_namespace.datadog,
    aws_eks_node_group.pitflow_nodes
  ]

  wait = true
}