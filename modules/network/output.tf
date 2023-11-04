output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "private_subnet_1a" {
  value = aws_subnet.eks_subnet_private_1a.id
}

output "private_subnet_1b" {
  value = aws_subnet.eks_subnet_private_1b.id
}

output "default_security_group_id" {
  value = aws_vpc.eks_vpc.default_security_group_id
}

output "subnet_group_name" {
  value = aws_db_subnet_group.rds_public_subnet_group.name
}