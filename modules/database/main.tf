## ------------------------------------------
## DATABASE MODULE
## ------------------------------------------

## Parameter Group
resource "aws_db_parameter_group" "mysql8-param-group" {
  name   = var.db_parameter_group_name
  family = var.db_parameter_group_family

  lifecycle {
    create_before_destroy = true
  }

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

## DB subnet group
resource "aws_db_subnet_group" "db-private-subnet-group" {
  name       = "main"
  subnet_ids = var.db_private_subnet_ids
}

## RDS MySQL instance
resource "aws_db_instance" "mysql-db" {
  db_subnet_group_name   = aws_db_subnet_group.db-private-subnet-group.id
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage
  db_name                = var.db_name
  port                   = var.db_port
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.mysql8-param-group.name
  skip_final_snapshot    = var.db_skip_final_snapshot
  publicly_accessible    = var.db_publicly_accessible
  multi_az               = var.db_multi_az
  vpc_security_group_ids = var.db_vpc_security_group_ids

  tags = {
    Name        = "rds-db-${var.db_environment}"
    Environment = "${var.db_environment}"
  }
}
