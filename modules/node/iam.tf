resource "aws_iam_role" "eks_node_role" {
  name = format("%s-node-role", var.cluster_name)

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_policy" "eks_node_ssm_access" {
  name        = format("%s-node-role", var.cluster_name)
  description = "Permite que os nodes do EKS acessem parâmetros específicos no SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:DescribeParameters"],
        Resource = "arn:aws:ssm:${var.region}:${var.account_id}:parameter${var.parameter_prefix}/*"
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_nodes_ssm" {
  policy_arn = aws_iam_policy.eks_node_ssm_access.arn
  role       = aws_iam_role.eks_node_role.name
}



