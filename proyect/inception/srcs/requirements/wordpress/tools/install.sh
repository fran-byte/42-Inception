#!/bin/sh
set -e

echo "📥 Descargando WordPress..."

# Instalar WP-CLI si no está presente
if ! command -v wp >/dev/null 2>&1; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Descargar WordPress en /tmp/wordpress para la imagen
mkdir -p /tmp/wordpress
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /tmp/wordpress --strip-components=1
rm /tmp/wordpress.tar.gz

echo "✅ WordPress descargado y listo en /tmp/wordpress"
