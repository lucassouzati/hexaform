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

  username = var.db_username
  password = random_string.rds-db-password.result


  depends_on = [
    aws_security_group.rds_sg_ingress
  ]
}
