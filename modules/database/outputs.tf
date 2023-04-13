output "db_instance_address" {
  value = aws_db_instance.mysql_db.address
}

output "db_instance_username" {
  value = aws_db_instance.mysql_db.username
}
