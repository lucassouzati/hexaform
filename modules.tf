locals {
  parameter_prefix = "/${var.env}/${var.cluster_name}"
}

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
  account_id = data.aws_caller_identity.current.account_id
  region = var.region
}

module "database" {
  source = "./modules/database"
  db_name = var.db_name
  db_instance_type = var.db_instance_type
  db_allocated_storage = var.db_allocated_storage
  db_engine = var.db_engine
  db_version = var.db_version
  db_username = var.db_username
  vpc_id = module.network.vpc_id
  default_security_group_id = module.network.default_security_group_id
}

module "env" {
  source = "./modules/env"
  db_host = module.database.db_host
  db_database = module.database.db_database
  db_username = module.database.db_username
  db_password = module.database.db_password
  parameter_prefix = local.parameter_prefix
}

data "aws_caller_identity" "current" {}
