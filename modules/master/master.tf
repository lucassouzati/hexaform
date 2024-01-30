resource "aws_eks_cluster" "eks_cluster" {

  name     = var.cluster_name
  role_arn = var.lab_role_arn
  version  = var.kubernetes_version
  
  vpc_config {

      subnet_ids = [
          var.private_subnet_1a, 
          var.private_subnet_1b
      ]
      
  }

  # depends_on = [
  #   aws_iam_role_policy_attachment.eks_cluster_cluster,
  #   aws_iam_role_policy_attachment.eks_cluster_service
  # ]

}

# Create Elastic Container Registry (ECR)
resource "aws_ecr_repository" "hexafood_pedido" {
  name = var.ecr_repository_name_hexafood_pedido

  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "hexafood_producao" {
  name = var.ecr_repository_name_hexafood_producao

  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "hexafood_pagamento" {
  name = var.ecr_repository_name_hexafood_pagamento

  image_tag_mutability = "MUTABLE"
}
