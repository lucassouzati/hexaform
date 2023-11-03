variable "cluster_name" {}

variable "private_subnet_1a" {}

variable "private_subnet_1b" {}

variable "desired_size" {}

variable "max_size" {}

variable "min_size" {}

variable "nodes_instances_type" {}

variable "parameter_prefix" {}

# variable "account_id" {}

variable "region" {}

variable "eks_url" {}

variable "cluster_id" {
  description = "The EKS cluster ID"
  type        = string
}

variable "issuer" {}