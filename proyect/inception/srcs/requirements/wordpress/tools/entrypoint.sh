#!/bin/sh
set -e

# Leer secrets
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_wp_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_REGULAR_PASSWORD=$(cat /run/secrets/wp_regular_password)

# Inicializar WordPress en el volumen si está vacío
if [ -z "$(ls -A /var/www/html)" ]; then
    echo "📦 Volumen de WordPress vacío, copiando archivos..."
    cp -a /tmp/wordpress/. /var/www/html/
    chown -R nobody:nobody /var/www/html
fi

echo "⏳ Esperando a que MariaDB esté lista..."
while ! mysqladmin ping -h"${WORDPRESS_DB_HOST%%:*}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    sleep 2
done
echo "✅ MariaDB disponible."

# Crear wp-config.php si no existe
if [ ! -f /var/www/html/wp-config.php ]; then
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

# Instalar WordPress si no está instalado
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WORDPRESS_SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    wp user create "${WP_REGULAR_USER}" "${WP_REGULAR_EMAIL}" \
        --user_pass="${WP_REGULAR_PASSWORD}" \
        --role=author \
        --allow-root
fi

# Reemplazar usuarios placeholder si existen
for placeholder in placeholder_admin placeholder_user; do
    if wp user get "$placeholder" --allow-root >/dev/null 2>&1; then
        case $placeholder in
            placeholder_admin)
                wp user update "$placeholder" --user_login="${WP_ADMIN_USER}" --user_pass="${WP_ADMIN_PASSWORD}" --user_email="${WP_ADMIN_EMAIL}" --display_name="${WP_ADMIN_USER}" --allow-root
                ;;
            placeholder_user)
                wp user update "$placeholder" --user_login="${WP_REGULAR_USER}" --user_pass="${WP_REGULAR_PASSWORD}" --user_email="${WP_REGULAR_EMAIL}" --display_name="${WP_REGULAR_USER}" --allow-root
                ;;
        esac
    fi
done

# Ajustar permisos finales
chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "✅ WordPress configurado correctamente"

# Iniciar PHP-FPM
exec php-fpm83 -F
