output "db_password" {
    value = random_string.rds-db-password.result
}

output "db_host" {
  value = aws_db_instance.rds-db-instance.endpoint
}

output "db_username" {
  value = aws_db_instance.rds-db-instance.username
}

output "db_database" {
  value = aws_db_instance.rds-db-instance.db_name
}

output "db_password_hexafood_pagamento" {
    value = random_string.rds-db-password-hexafood_pagamento.result
}

output "db_host_hexafood_pagamento" {
  value = aws_db_instance.rds-db-instance-hexafood_pagamento.endpoint
}

output "db_username_hexafood_pagamento" {
  value = aws_db_instance.rds-db-instance-hexafood_pagamento.username
}

output "db_database_hexafood_pagamento" {
  value = aws_db_instance.rds-db-instance-hexafood_pagamento.db_name
}
