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
