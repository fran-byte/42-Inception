#!/bin/bash

set -e

echo "🔧 Actualizando paquetes..."
apt update

echo "📦 Instalando PHP-FPM y extensiones necesarias..."
DEBIAN_FRONTEND=noninteractive apt install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    unzip \
    mariadb-client

echo "🌐 Descargando WordPress..."
wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip
unzip /tmp/wordpress.zip -d /var/www/
rm /tmp/wordpress.zip

echo "🔧 Configurando permisos..."
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

echo "🧩 Reconfigurando PHP-FPM para escuchar en el puerto 9000..."
PHP_POOL_CONF=$(find /etc/php -name www.conf | head -n 1)
sed -i 's|^listen = .*|listen = 9000|' "$PHP_POOL_CONF"
sed -i 's|^;listen.allowed_clients =.*|listen.allowed_clients = 127.0.0.1|' "$PHP_POOL_CONF"

echo "🎉 WordPress instalado y PHP-FPM corriendo"

exec php-fpm -F

