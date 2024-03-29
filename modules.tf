locals {
  parameter_prefix = "/${var.env}/${var.cluster_name}"
}
data "aws_caller_identity" "current" {}


module "network" {
  source = "./modules/network"

  cluster_name = var.cluster_name
  region = var.region
}

module "master" {
  source = "./modules/master"

  cluster_name = var.cluster_name
  kubernetes_version = var.kubernetes_version

  private_subnet_1a = module.network.private_subnet_1a
  private_subnet_1b = module.network.private_subnet_1b
  lab_role_arn = local.lab_role_arn
  ecr_repository_name_hexafood_pedido = var.ecr_repository_name_hexafood_pedido
  ecr_repository_name_hexafood_producao = var.ecr_repository_name_hexafood_producao
  ecr_repository_name_hexafood_pagamento = var.ecr_repository_name_hexafood_pagamento
}

module "node" {
  source = "./modules/node"

  cluster_name = module.master.cluster_name

  private_subnet_1a = module.network.private_subnet_1a
  private_subnet_1b = module.network.private_subnet_1b

  desired_size = var.auto_scale_options.desired
  min_size = var.auto_scale_options.min
  max_size = var.auto_scale_options.max

  nodes_instances_type = var.nodes_instances_type
  parameter_prefix = local.parameter_prefix
  # account_id = data.aws_caller_identity.current.account_id
  region = var.region
  eks_url = module.master.eks_url
  cluster_id = module.master.cluster_id
  issuer = module.master.issuer
  lab_role_arn = local.lab_role_arn
}

module "database" {
  source = "./modules/database"
  db_name = var.db_name
  db_instance_type = var.db_instance_type
  db_allocated_storage = var.db_allocated_storage
  db_engine = var.db_engine
  db_version = var.db_version
  db_username = var.db_username
  default_security_group_id = module.master.security_group_id
  db_subnet_group_name = module.network.subnet_group_name
  db_name_hexafood_pagamento = var.db_name_hexafood_pagamento
  db_username_hexafood_pagamento = var.db_username_hexafood_pagamento
}

module "message_broker" {
  source = "./modules/message_broker"
  novo_pedido_queue = var.novo_pedido_queue
  pagamento_processado_queue = var.pagamento_processado_queue
  pedido_recebido_queue = var.pedido_recebido_queue
  pedido_finalizado_queue = var.pedido_finalizado_queue
}

module "env" {
  source = "./modules/env"
  db_host = module.database.db_host
  db_database = var.db_name
  db_username = var.db_username
  db_password = module.database.db_password
  parameter_prefix = local.parameter_prefix
  novo_pedido_queue_url = module.message_broker.novo_pedido_queue_url
  pagamento_processado_queue_url = module.message_broker.pagamento_processado_queue_url
  pedido_recebido_queue_url = module.message_broker.pedido_recebido_queue_url
  db_password_hexafood_pagamento = module.database.db_password_hexafood_pagamento
  db_host_hexafood_pagamento = module.database.db_host_hexafood_pagamento
  db_username_hexafood_pagamento = module.database.db_username_hexafood_pagamento
  db_database_hexafood_pagamento = module.database.db_database_hexafood_pagamento
  dynamodb_endpoint = var.dynamodb_endpoint
}


output "pod_service_account_role_arn" {
  value = local.lab_role_arn
  sensitive = true
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
  sensitive = true
}

output "db_connection_string" {
  value = format("postgresql://%s:%s@%s/%s", module.database.db_username, module.database.db_password, module.database.db_host, module.database.db_database)
  sensitive = true
}

output "db_password_hexafood_pagamento" {
  value = module.database.db_password_hexafood_pagamento
}
output "db_host_hexafood_pagamento" {
  value = module.database.db_host_hexafood_pagamento
}
output "db_username_hexafood_pagamento" {
  value = module.database.db_username_hexafood_pagamento
}
output "db_database_hexafood_pagamento" {
  value = module.database.db_database_hexafood_pagamento
}