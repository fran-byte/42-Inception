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
    wget --no-check-certificate https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -a /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    chown -R nobody:nobody /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
fi

echo "✅ WordPress listo en /var/www/html"

# Verificar si wp-config.php existe
if [ -f /var/www/html/wp-config.php ]; then
    echo "✅ wp-config.php encontrado"
    echo "👥 Creando usuarios de WordPress..."
    php /usr/local/bin/init-users.php || echo "⚠ Fallo al ejecutar init-users.php"
else
    echo "⚠ wp-config.php no encontrado"
    echo "⏳ Esperando a que MariaDB esté disponible..."
    
    # Esperar máximo 30 segundos a que MariaDB esté lista
    counter=0
    until mysql -h mariadb -u wp_to_db_user -pwordpresspass -e "SELECT 1;" &> /dev/null; do
        sleep 2
        counter=$((counter + 1))
        if [ $counter -ge 15 ]; then
            echo "❌ Timeout: MariaDB no está disponible después de 30 segundos"
            break
        fi
    done
    
    # Si MariaDB está disponible, instalar WordPress
    if mysql -h mariadb -u wp_to_db_user -pwordpresspass -e "SELECT 1;" &> /dev/null; then
        echo "🔧 Creando wp-config.php..."
        wp config create \
            --dbhost=mariadb \
            --dbname=wordpress \
            --dbuser=wp_to_db_user \
            --dbpass="$(cat /run/secrets/wp_to_db_user_password)" \
            --allow-root \
            --path=/var/www/html
        
        echo "🚀 Instalando WordPress..."
        wp core install \
            --url=https://frromero.42.fr \
            --title="Inception Project" \
            --admin_user=wp_manager_user \
            --admin_password="$(cat /run/secrets/wp_manager_password)" \
            --admin_email=manager@42.fr \
            --skip-email \
            --allow-root \
            --path=/var/www/html
        
        echo "✅ WordPress instalado correctamente via CLI"
        
        # Crear usuarios adicionales si existe el script
        if [ -f /usr/local/bin/init-users.php ]; then
            echo "👥 Creando usuarios adicionales..."
            php /usr/local/bin/init-users.php || echo "⚠ Fallo al ejecutar init-users.php"
        fi
    else
        echo "⚠ No se pudo instalar WordPress: MariaDB no disponible"
    fi
fi

# Iniciar PHP-FPM en primer plano
echo "🌐 Iniciando PHP-FPM..."
exec php-fpm83 -F
