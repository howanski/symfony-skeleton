#!/bin/bash
export PATH="/bin-cache:$PATH"
apt update
apt install -y unzip libpq-dev
docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
docker-php-ext-install pdo_mysql
docker-php-ext-install pdo pdo_pgsql

if [ ! -f "/bin-cache/composer.phar" ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/bin-cache
    php -r "unlink('composer-setup.php');"
    chown $UID:$GID /bin-cache/composer.phar
fi

if [ ! -f "/bin-cache/symfony" ]; then
    curl -sS https://get.symfony.com/cli/installer | bash
    mv "$HOME/.symfony5/bin/symfony" "/bin-cache"
    chown $UID:$GID /bin-cache/symfony
fi

if [ ! -d "symfony" ]; then
    apt install -y git
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git config --global safe.directory '/var/www/html/symfony'
    symfony new symfony --version="$SYMFONY_VERSION" "$SYMFONY_VERSION_FLAGS"
    rm -rf symfony/.git
fi

cd symfony

if [ ! -d "vendor" ]; then
    composer.phar install
fi

php bin/console cache:clear

chown -R $UID:$GID .

# TODO: healthcheck on compose instead of manual polling?
# MYSQL
# until XDEBUG_MODE=off php bin/console dbal:run-sql -q "show tables"; do
# 	echo "--------------------------------"
# 	echo "------ [ WAITING FOR DB ] ------"
# 	echo "--------------------------------"
#     date
# 	sleep 5
# done

php bin/console doctrine:migrations:migrate

php bin/console assets:install public
php bin/console importmap:install

chown -R $UID:$GID .

echo "user = $UID" >> $PHP_FPM_CONF_FILE
echo "group = $GID" >> $PHP_FPM_CONF_FILE

# TODO: apt install supervisor, move background tasks there
# php bin/console messenger:consume async > /dev/null 2>&1 &
# php bin/console messenger:consume -v another > /dev/null 2>&1 &

php-fpm
