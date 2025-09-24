#!/bin/sh
set -e

# Ajustar permisos del volumen de WordPress
echo "📦 Ajustando permisos de /var/www/html..."
chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Descargar y descomprimir WordPress si el volumen está vacío
if [ -z "$(ls -A /var/www/html)" ]; then
    echo "📦 Volumen de WordPress vacío, copiando archivos..."
    wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -a /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    chown -R nobody:nobody /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
fi

echo "✅ WordPress listo en /var/www/html"

# Iniciar PHP-FPM en primer plano
exec php-fpm83 -F
