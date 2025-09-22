#!/bin/sh
set -e

echo "Esperando a que MariaDB esté disponible..."
while ! mysqladmin ping -h"${WORDPRESS_DB_HOST%%:*}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    echo "MariaDB no disponible aún, esperando..."
    sleep 2
done

echo "MariaDB está disponible, configurando WordPress..."

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creando wp-config.php..."
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root \
        --skip-check

    wp config set WP_HOME "https://${DOMAIN_NAME}" --allow-root
    wp config set WP_SITEURL "https://${DOMAIN_NAME}" --allow-root
    wp config set DISALLOW_FILE_EDIT true --allow-root
    wp config set FS_METHOD direct --allow-root
fi

if ! wp core is-installed --allow-root; then
    echo "Instalando WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception Project" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "Creando usuario adicional..."
    wp user create "${WP_REGULAR_USER}" "${WP_REGULAR_EMAIL}" \
        --user_pass="${WP_REGULAR_PASSWORD}" \
        --role=author \
        --allow-root
fi

echo "WordPress configurado correctamente"

chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "Iniciando PHP-FPM..."
exec php-fpm83 -F
