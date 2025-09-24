#!/bin/sh
set -e

# Leer secret de la base de datos
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/wpuser_db_password)

# Inicializar WordPress en el volumen si está vacío
if [ -z "$(ls -A /var/www/html)" ]; then
    echo "📦 Volumen de WordPress vacío, copiando archivos..."
    cp -a /tmp/wordpress/. /var/www/html/
    chown -R nobody:nobody /var/www/html
fi

echo "⏳ Esperando a que MariaDB esté lista..."
while ! mysqladmin ping -h"${WORDPRESS_DB_HOST%%:*}" -u"wpuser" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    sleep 2
done
echo "✅ MariaDB disponible."

# Ajustar permisos finales
chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "✅ WordPress listo"

# Iniciar PHP-FPM
exec php-fpm83 -F
