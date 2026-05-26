data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # Houve um erro então estou excluindo us-east-1e
  filter {
    name   = "availabilityZone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.pitflow_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.pitflow_cluster.name
}


data "aws_secretsmanager_secret" "pitflow" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "pitflow" {
  secret_id = data.aws_secretsmanager_secret.pitflow.id
}