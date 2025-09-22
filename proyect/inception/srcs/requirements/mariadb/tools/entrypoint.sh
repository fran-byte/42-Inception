#!/bin/sh
set -e

echo "🔧 Checking MariaDB initialization..."

if [ -z "$(ls -A /var/lib/mysql/mysql)" ]; then
    echo "📦 Initializing MariaDB system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "✅ System tables already exist"
fi

chown -R mysql:mysql /var/lib/mysql

echo "🔐 Configuring database and user..."

# Verificar que las variables de entorno existen
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "❌ ERROR: Environment variables not set!"
    exit 1
fi

echo "📝 Configuring with root password: ${MYSQL_ROOT_PASSWORD:0:5}..."

# Iniciar MariaDB temporal
mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock --skip-log-error &
MYSQL_PID=$!

# Esperar con verificación
sleep 5
until mysqladmin ping -S /tmp/mysql.sock --silent; do
    echo "⏳ Waiting for temporary MariaDB to start..."
    sleep 2
done

# Configurar usando VARIABLES DE ENTORNO, no leyendo archivos
mysql -S /tmp/mysql.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Database and user configured successfully"
else
    echo "❌ ERROR: Failed to configure database"
    exit 1
fi

kill $MYSQL_PID
wait $MYSQL_PID

echo "✅ Starting MariaDB..."
exec mysqld --user=mysql --console
