#!/bin/bash

# Set env
printf "\nexport NODE_ENV=production\nexport PROD_APP_PORT=3001\nexport PROD_SQL_HOST=localhost\nexport PROD_SQL_USER=webapp\nexport PROD_SQL_PASS=MyNewPass4!\nexport PROD_SQL_DB=webapp\nexport PROD_DB_DIALECT=mysql" >> ~/.bashrc
source ~/.bashrc