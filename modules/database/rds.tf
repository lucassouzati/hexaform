resource "random_string" "rds-db-password" {
  length  = 32
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_instance" "rds-db-instance" {
  instance_class    = var.db_instance_type
  allocated_storage = var.db_allocated_storage
  engine            = var.db_engine
  skip_final_snapshot = true
  publicly_accessible = true

  db_name = var.db_name
  username = var.db_username
  password = random_string.rds-db-password.result

  vpc_security_group_ids = [var.default_security_group_id]
  db_subnet_group_name = var.db_subnet_group_name

  depends_on = [
    aws_security_group_rule.rds_sg_ingress_rule
  ]
}

resource "random_string" "rds-db-password-hexafood_pagamento" {
  length  = 32
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_instance" "rds-db-instance-hexafood_pagamento" {
  instance_class    = var.db_instance_type
  allocated_storage = var.db_allocated_storage
  engine            = var.db_engine
  skip_final_snapshot = true
  publicly_accessible = true
  db_name = var.db_name_hexafood_pagamento

  username = var.db_username_hexafood_pagamento
  password = random_string.rds-db-password.result

  vpc_security_group_ids = [var.default_security_group_id]
  db_subnet_group_name = var.db_subnet_group_name

  depends_on = [
    aws_security_group_rule.rds_sg_ingress_rule
  ]
}







