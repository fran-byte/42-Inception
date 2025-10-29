#!/bin/sh
set -e

# --------------------------------------------------
# WordPress Entrypoint: Starting container initialization
# --------------------------------------------------

# --------------------------------------------------
# Adjusting permissions for /var/www/html
# --------------------------------------------------
chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# --------------------------------------------------
# Checking if WordPress volume is empty
# --------------------------------------------------
if [ -z "$(ls -A /var/www/html)" ]; then
    # Empty WordPress volume detected, copying files
    wget --no-check-certificate https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -a /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    # Reset permissions
    chown -R nobody:nobody /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
fi

# --------------------------------------------------
# Checking for wp-config.php
# --------------------------------------------------
if [ -f /var/www/html/wp-config.php ]; then
    # Wait until WordPress is fully initialized
    until wp core is-installed --allow-root --path=/var/www/html 2>/dev/null; do
        sleep 3
    done

    # Create WordPress users via init-users.php
    php /usr/local/bin/init-users.php || true

else
    # Read database password from secret
    DB_PASSWORD=$(cat /run/secrets/wp_to_db_user_password)

    # Wait up to 30 seconds for MariaDB
    counter=0
    until mysql -h mariadb -u wp_to_db_user -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; do
        sleep 2
        counter=$((counter + 1))
        if [ $counter -ge 15 ]; then
            break
        fi
    done

    if mysql -h mariadb -u wp_to_db_user -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; then
        # Create wp-config.php
        wp config create \
            --dbhost=mariadb \
            --dbname=wordpress \
            --dbuser=wp_to_db_user \
            --dbpass="$DB_PASSWORD" \
            --allow-root \
            --path=/var/www/html

        # Install WordPress tables
        wp core install \
            --url="https://${DOMAIN_NAME}" \
            --title="${WORDPRESS_SITE_TITLE}" \
            --admin_user="${WORDPRESS_ADMIN_USER}" \
            --admin_password="$(cat /run/secrets/wp_manager_password)" \
            --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
            --skip-email \
            --allow-root \
            --path=/var/www/html

        # Create additional WordPress users if init-users.php exists
        if [ -f /usr/local/bin/init-users.php ]; then
            php /usr/local/bin/init-users.php || true
        fi
    fi
fi

# --------------------------------------------------
# Starting PHP-FPM in foreground
# --------------------------------------------------
exec php-fpm83 -F
