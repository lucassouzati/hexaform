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

resource "aws_ssm_parameter" "database_url" {
  name  = "${var.parameter_prefix}/database_url"
  type  = "String"
  value = format("postgresql://%s:%s@%s/%s", 
                  var.db_username,  
                  var.db_password, 
                  var.db_host, 
                  var.db_database)
}

resource "aws_ssm_parameter" "novo_pedido_queue_url" {
  name  = "${var.parameter_prefix}/novo_pedido_queue_url"
  type  = "String"
  value = var.novo_pedido_queue_url
}

resource "aws_ssm_parameter" "pagamento_processado_queue_url" {
  name  = "${var.parameter_prefix}/pagamento_processado_queue_url"
  type  = "String"
  value = var.pagamento_processado_queue_url
}

resource "aws_ssm_parameter" "pedido_recebido_queue_url" {
  name  = "${var.parameter_prefix}/pedido_recebido_queue_url"
  type  = "String"
  value = var.pedido_recebido_queue_url
}

resource "aws_ssm_parameter" "db_host_hexafood_pagamento" {
  name  = "${var.parameter_prefix}/hexafood_pagamento/host"
  type  = "String"
  value = var.db_host_hexafood_pagamento
}

resource "aws_ssm_parameter" "db_database_hexafood_pagamento" {
  name  = "${var.parameter_prefix}/hexafood_pagamento/database"
  type  = "String"
  value = var.db_database_hexafood_pagamento
}

resource "aws_ssm_parameter" "db_username_hexafood_pagamento" {
  name  = "${var.parameter_prefix}/hexafood_pagamento/username"
  type  = "String"
  value = var.db_username_hexafood_pagamento
}

resource "aws_ssm_parameter" "db_password_hexafood_pagamento" {
  name  = "${var.parameter_prefix}/hexafood_pagamento/password"
  type  = "SecureString"
  value = var.db_password_hexafood_pagamento
  key_id = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "dynamodb_endpoint" {
  name  = "${var.parameter_prefix}/dynamodb_host"
  type  = "String"
  value = var.dynamodb_endpoint
  key_id = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "novo_pedido_queue_name" {
  name  = "${var.parameter_prefix}/AWS_SQS_NOVO_PEDIDO_QUEUE_NAME"
  type  = "String"
  value = "novo_pedido"
  key_id = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "pagamento_processado_queue_name" {
  name  = "${var.parameter_prefix}/AWS_SQS_PAGAMENTO_PROCESSADO_QUEUE_NAME"
  type  = "String"
  value = "pagamento_processado"
  key_id = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "pedido_recebido_queue_name" {
  name  = "${var.parameter_prefix}/AWS_SQS_PEDIDO_RECEBIDO_QUEUE_NAME"
  type  = "String"
  value = "pedido_recebido"
  key_id = "alias/aws/ssm"
}