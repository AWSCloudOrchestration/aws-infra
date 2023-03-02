#!/bin/bash
printf "\nexport NODE_ENV=production\nexport APP_PORT=3001\nexport PROD_SQL_HOST=${rds_address}\nexport PROD_SQL_USER=${rds_username}\nexport PROD_SQL_PASS=${rds_password}\nexport PROD_SQL_DB=${rds_db_name}\nexport PROD_DB_DIALECT=mysql\nexport AWS_S3_BUCKET_NAME=${s3_instance_bucket_name}\nexport AWS_REGION=${s3_aws_region}" >> ~/.bashrc
source ~/.bashrc
npm run migratedb --prefix /home/ec2-user/webapp

printf "\nNODE_ENV=production\nAPP_PORT=3001\nPROD_SQL_HOST=${rds_address}\nPROD_SQL_USER=${rds_username}\nPROD_SQL_PASS=${rds_password}\nPROD_SQL_DB=${rds_db_name}\nPROD_DB_DIALECT=mysql\nAWS_S3_BUCKET_NAME=${s3_instance_bucket_name}\nAWS_REGION=${s3_aws_region}" >> /var/webapp/webappvars
sudo systemctl restart webapp.service