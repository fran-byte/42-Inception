#!/bin/bash

set -e

echo "🔧 Actualizando paquetes..."
apt update

echo "📦 Instalando MariaDB..."
DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server

echo "✅ MariaDB instalado. Iniciando servicio..."
service mysql start

echo "🔐 Configurando base de datos..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "🎉 Instalación completa."
tail -f /dev/null  # Mantiene el contenedor vivo
