#!/bin/bash
printf "\nexport NODE_ENV=${webapp_env}\nexport APP_PORT=${webapp_port}\nexport SQL_HOST=${rds_address}\nexport SQL_USER=${rds_username}\nexport SQL_PASS=${rds_password}\nexport SQL_DB=${rds_db_name}\nexport DB_DIALECT=mysql\nexport AWS_S3_BUCKET_NAME=${s3_instance_bucket_name}\nexport AWS_REGION=${s3_aws_region}" >> ~/.bashrc
source ~/.bashrc
npm run migratedb --prefix /home/ec2-user/webapp

printf "\nNODE_ENV=${webapp_env}\nAPP_PORT=${webapp_port}\nSQL_HOST=${rds_address}\nSQL_USER=${rds_username}\nSQL_PASS=${rds_password}\nSQL_DB=${rds_db_name}\nDB_DIALECT=mysql\nAWS_S3_BUCKET_NAME=${s3_instance_bucket_name}\nAWS_REGION=${s3_aws_region}" >> /var/webapp/webappvars
sudo systemctl restart webapp.service