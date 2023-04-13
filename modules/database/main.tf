#############################################
## DATABASE MODULE
#############################################

module "globals" {
  source = "../globals"
}

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

## KMS Key Policy
resource "aws_kms_key_policy" "rds_kms_policy" {
  key_id = module.rds_kms.kms_key_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${module.globals.caller_account_id}:user/awscli"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : [module.rds_kms.kms_key_id]
      }
    ]
  })
}

## KMS Key
module "rds_kms" {
  source = "../kms"

  kms_description             = "RDS KMS Key"
  kms_deletion_window_in_days = var.kms_deletion_window_in_days

}

## DB subnet group
resource "aws_db_subnet_group" "db-private-subnet-group" {
  name       = "main"
  subnet_ids = var.db_private_subnet_ids
}

## RDS MySQL instance
resource "aws_db_instance" "mysql_db" {
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
  storage_encrypted      = var.db_storage_encrypted
  kms_key_id             = module.rds_kms.kms_key_id


  tags = {
    Name        = "rds-db-${var.db_environment}"
    Environment = "${var.db_environment}"
  }
}
