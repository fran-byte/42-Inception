#!/bin/sh
set -e

# -----------------------------
# WordPress Entrypoint
# Main script executed when WordPress container starts
# -----------------------------

# -----------------------------
# Adjust permissions for WordPress volume
# -----------------------------
echo "---> Adjusting permissions for /var/www/html..."
chown -R nobody:nobody /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# -----------------------------
# Download and extract WordPress if volume is empty
# -----------------------------
if [ -z "$(ls -A /var/www/html)" ]; then
    echo "---> Empty WordPress volume, copying files..."
    wget --no-check-certificate https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -a /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    chown -R nobody:nobody /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
fi

# -----------------------------
# Check if wp-config.php exists
# -----------------------------
if [ -f /var/www/html/wp-config.php ]; then
    echo " wp-config.php found"

    # -----------------------------
    # Wait until WordPress is fully initialized
    # -----------------------------
    echo "---> Waiting for WordPress to be ready..."
    until wp core is-installed --allow-root --path=/var/www/html 2>/dev/null; do
        echo "---> WordPress not ready, waiting..."
        sleep 3
    done

    # -----------------------------
    # Create WordPress users
    # -----------------------------
    echo "---> Creating WordPress users..."
    php /usr/local/bin/init-users.php || echo "⚠ Failed to run init-users.php"

else
    echo "---> wp-config.php not found"
    echo "---> Waiting for MariaDB to be available..."

    # -----------------------------
    # Read database password from secret
    # -----------------------------
    DB_PASSWORD=$(cat /run/secrets/wp_to_db_user_password)

    # -----------------------------
    # Wait up to 30 seconds for MariaDB
    # -----------------------------
    counter=0
    until mysql -h mariadb -u wp_to_db_user -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; do
        sleep 2
        counter=$((counter + 1))
        if [ $counter -ge 15 ]; then
            echo "❌ Timeout: MariaDB not available after 30 seconds"
            break
        fi
    done

    # -----------------------------
    # Install WordPress TABLES if MariaDB is ready
    # -----------------------------
    if mysql -h mariadb -u wp_to_db_user -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; then
        echo "---> Creating wp-config.php..."
        wp config create \
            --dbhost=mariadb \
            --dbname=wordpress \
            --dbuser=wp_to_db_user \
            --dbpass="$DB_PASSWORD" \
            --allow-root \
            --path=/var/www/html

        echo "---> Installing TABLES in WordPress..."
        wp core install \
            --url="https://${DOMAIN_NAME}" \
            --title="${WORDPRESS_SITE_TITLE}" \
            --admin_user="${WORDPRESS_ADMIN_USER}" \
            --admin_password="$(cat /run/secrets/wp_manager_password)" \
            --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
            --skip-email \
            --allow-root \
            --path=/var/www/html

        echo " WordPress TABLES installed successfully via CLI"
        
        # -----------------------------
        # Create additional users if init-users.php exists
        # -----------------------------
        if [ -f /usr/local/bin/init-users.php ]; then
            echo "---> Creating additional users..."
            php /usr/local/bin/init-users.php || echo "⚠ Failed to run init-users.php"
        fi
    else
        echo "---> Could not install WordPress: MariaDB unavailable"
    fi
fi

# -----------------------------
# Start PHP-FPM in foreground
# -----------------------------
echo " Starting PHP-FPM..."
exec php-fpm83 -F
