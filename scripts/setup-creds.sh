#!/bin/bash
printf "\nexport NODE_ENV=${webapp_env}\nexport APP_PORT=${webapp_port}\nexport SQL_HOST=${rds_address}\nexport SQL_USER=${rds_username}\nexport SQL_PASS=${rds_password}\nexport SQL_DB=${rds_db_name}\nexport DB_DIALECT=mysql\nexport AWS_S3_BUCKET_NAME=${s3_instance_bucket_name}\nexport AWS_REGION=${s3_aws_region}" >> ~/.bashrc
source ~/.bashrc
npm run migratedb --prefix /home/ec2-user/webapp

printf "NODE_ENV=${webapp_env}\n\
APP_PORT=${webapp_port}\n\
SQL_HOST=${rds_address}\n\
SQL_USER=${rds_username}\n\
SQL_PASS=${rds_password}\n\
SQL_DB=${rds_db_name}\n\
DB_DIALECT=mysql\n\
AWS_S3_BUCKET_NAME=${s3_instance_bucket_name}\n\
AWS_REGION=${s3_aws_region}\n\
SQL_MAX_POOL_CONN=${sql_max_pool_conn}\n\
SQL_CONN_MAX_RETRIES=${sql_max_retries}\n\
STATSD_HOST=${statsd_host}\n\
STATSD_PORT=${statsd_port}\n\
STATSD_PREFIX=${statsd_prefix}\n\
STATSD_CACHE_DNS=${statsd_cache_dns}
APP_LOGS_DIRNAME=${app_logs_dirname}
APP_ERROR_LOGS_DIRNAME=${app_error_logs_dirname}" >> /var/webapp/webappvars
sudo systemctl restart webapp.service

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/cloudwatch-config.json \
    -s