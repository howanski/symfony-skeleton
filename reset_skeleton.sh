#!/bin/bash
clear
source .env
rm -f bin-cache/composer.phar
rm -f bin-cache/symfony
rm -f caddy/cert.pem
rm -f caddy/key.pem
rm -rf app/symfony
rm -rf ide_data
rm -rf postgres_data
rm -rf mysql_data
docker rm $APP_NAME-web-1 2> /dev/null
docker rm $APP_NAME-php-1 2> /dev/null
docker rm $APP_NAME-db-1 2> /dev/null
docker rm $APP_NAME-ide-1 2> /dev/null
echo "skeleton have ben reset"
