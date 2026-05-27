resource "aws_eks_cluster" "pitflow_cluster" {
  name     = var.eks_cluster_name
  role_arn = data.aws_iam_role.lab_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }
}


resource "aws_eks_node_group" "pitflow_nodes" {
  cluster_name    = aws_eks_cluster.pitflow_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = data.aws_iam_role.lab_role.arn

  subnet_ids = data.aws_subnets.default.ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }
  
  tags = {
    "k8s.io/cluster-autoscaler/enabled"     = "true"
    "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
  }

  instance_types = ["t3.medium"]
  capacity_type  = "SPOT"
  #capacity_type  = "ON_DEMAND"
}

output "eks_cluster_name" {
  value = aws_eks_cluster.pitflow_cluster.name
}