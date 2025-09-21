#!/bin/sh

set -e

echo "Iniciando instalación de WordPress..."

# Instalar WP-CLI
echo "Instalando WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Descargar WordPress
echo "Descargando WordPress..."
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /tmp
cp -a /tmp/wordpress/. /var/www/html/
rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

# Configurar permisos
echo "Configurando permisos..."
chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Crear directorio para uploads
mkdir -p /var/www/html/wp-content/uploads
chown -R nobody:nobody /var/www/html/wp-content/uploads
chmod 775 /var/www/html/wp-content/uploads

echo "Instalación de WordPress completada"
