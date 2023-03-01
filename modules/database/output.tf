output "db_instance_address" {
  value = aws_db_instance.mysql-db.address
}

output "db_instance_username" {
  value = aws_db_instance.mysql-db.username
}