variable "env"{
  default = "dev"
}

variable "account_id" {
  default = "637423636452"
}

variable "cluster_name" {
  default = "hexaform"
}

variable "region" {
  default = "us-east-1"
}

variable "kubernetes_version" {
  default = "1.27"
}

variable "nodes_instances_type" {
  default = [
    "t2.small"
  ]
}

variable "auto_scale_options" {
  default = {
    min     = 2
    max     = 4
    desired = 2
  }
}

variable "auto_scale_cpu" {
  default = {
    scale_up_threshold  = 80
    scale_up_period     = 60
    scale_up_evaluation = 2
    scale_up_cooldown   = 300
    scale_up_add        = 2

    scale_down_threshold  = 40
    scale_down_period     = 120
    scale_down_evaluation = 2
    scale_down_cooldown   = 300
    scale_down_remove     = -1
  }
}

variable "db_name" {
  default = "hexabase"
}

variable "db_name_hexafood_pagamento" {
  default = "hexabase_pagamento"
}

variable "db_instance_type" {
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  default = 5
}

variable "db_engine" {
  default = "postgres"
}

variable "db_version" {
  default = "12.5"
}

variable "db_username" {
  default = "hexabase"
}

variable "db_username_hexafood_pagamento" {
  default = "hexabase_hexafood_pagamento"
}

locals {
  lab_role_arn = "arn:aws:iam::${var.account_id}:role/LabRole"
}

variable "ecr_repository_name_hexafood_pedido"{
  default = "hexafood_pedido"
}
variable "ecr_repository_name_hexafood_producao"{
  default = "hexafood_producao"
}
variable "ecr_repository_name_hexafood_pagamento"{
  default = "hexafood_pagamento"
}

variable "novo_pedido_queue"{
  default = "novo_pedido"
}
variable "pagamento_processado_queue"{
  default = "pagamento_processado"
}
variable "pedido_recebido_queue"{
  default = "pedido_recebido"
}
variable "dynamodb_endpoint"{
  default = "https://dynamodb.us-east-1.amazonaws.com"
}

