output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.id
}

output "eks_url"{
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.cluster_id
}

output "issuer" {
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}