variable "aws_region" {
  description = "Região AWS usada pelos recursos da plataforma."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto usado nos recursos compartilhados."
  type        = string
  default     = "pitflow"
}

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

variable "secret_name" {
  description = "Secrets Manager secret read by the Lambda functions."
  type        = string
  default     = "pitflow/bootstrap"
}

variable "auth_lambda_name" {
  description = "Nome da função Lambda de autenticação."
  type        = string
  default     = "pitflow-auth"
}

variable "budget_form_lambda_name" {
  description = "Nome da função Lambda de formulário de orçamento."
  type        = string
  default     = "pitflow-budget-form"
}
