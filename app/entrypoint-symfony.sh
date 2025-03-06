#!/bin/bash
export PATH="/bin-cache:$PATH"
apt update
apt install -y unzip

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

chown -R $UID:$GID .

php-fpm
