resource "aws_ssm_parameter" "db_host" {
  name  = "${var.parameter_prefix}/host"
  type  = "String"
  value = var.db_host
}

resource "aws_ssm_parameter" "db_database" {
  name  = "${var.parameter_prefix}/database"
  type  = "String"
  value = var.db_database
}

resource "aws_ssm_parameter" "db_username" {
  name  = "${var.parameter_prefix}/username"
  type  = "String"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "${var.parameter_prefix}/password"
  type  = "SecureString"
  value = var.db_password
  key_id = "alias/aws/ssm"
}
