variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "pitflow-eks"
}

variable "eks_node_group_name" {
  description = "Nome do grupo de nós EKS"
  type        = string
  default     = "pitflow-node-group"
}

variable "ecr_repository_name" {
  description = "Nome do repositório ECR"
  type        = string
  default     = "pitflow-os-backend"
}