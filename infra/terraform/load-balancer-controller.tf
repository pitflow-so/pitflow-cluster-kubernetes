resource "helm_release" "aws_load_balancer_controller" {
  provider = helm.eks

  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.8.1"

  values = [
    yamlencode({
      clusterName = aws_eks_cluster.pitflow_cluster.name
      region      = var.aws_region
      vpcId       = data.aws_vpc.default.id
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
      }
    })
  ]

  depends_on = [
    null_resource.wait_for_eks,
    aws_eks_node_group.pitflow_nodes
  ]

  wait    = true
  timeout = 600
}

resource "kubernetes_ingress_v1" "pitflow_edge" {
  metadata {
    name      = "pitflow-edge"
    namespace = "default"

    annotations = {
      "alb.ingress.kubernetes.io/actions.platform-default" = jsonencode({
        type = "fixed-response"
        fixedResponseConfig = {
          contentType = "application/json"
          statusCode  = "503"
          messageBody = jsonencode({
            message = "PitFlow services are not deployed yet"
          })
        }
      })
      "alb.ingress.kubernetes.io/group.name"   = "pitflow"
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{ HTTP = 80 }])
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"      = join(",", data.aws_subnets.default.ids)
      "alb.ingress.kubernetes.io/target-type"  = "ip"
      "alb.ingress.kubernetes.io/tags"         = "Project=pitflow,Environment=lab,ManagedBy=terraform"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "platform-default"

              port {
                name = "use-annotation"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.aws_load_balancer_controller]
}
