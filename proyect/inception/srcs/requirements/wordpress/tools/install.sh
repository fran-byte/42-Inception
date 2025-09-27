#!/bin/sh
set -e

echo "📦 Instalando WP-CLI..."

# Instalar WP-CLI usando el método oficial
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Verificar instalación
wp --allow-root --version

echo "✅ WP-CLI instalado correctamente"
