#!/bin/sh
set -e

echo "🔧 Checking MariaDB initialization..."

# Configuración RÁPIDA sin reinstalar si ya existe
if [ -z "$(ls -A /var/lib/mysql/mysql)" ]; then
    echo "📦 Initializing MariaDB system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "✅ System tables already exist"
fi

chown -R mysql:mysql /var/lib/mysql

# ⭐⭐ CONFIGURACIÓN RÁPIDA ⭐⭐
echo "🔐 Configuring database and user..."

# Iniciar MariaDB temporal más rápido
mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock --skip-log-error &
MYSQL_PID=$!

# Esperar menos tiempo (3 segundos)
sleep 3

# Configuración rápida
mysql -S /tmp/mysql.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
EOF

kill $MYSQL_PID
wait $MYSQL_PID

echo "✅ Starting MariaDB..."
exec mysqld --user=mysql --console
