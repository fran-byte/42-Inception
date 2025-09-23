#!/bin/sh
set -e

echo "🔧 Inicializando MariaDB..."

# Leer secrets
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_wp_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wpuser}

# Inicializar DB si no existe
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "📦 Creando las tablas del sistema..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql

# Iniciar MariaDB temporal
mysqld --user=mysql --skip-networking &
MYSQL_PID=$!

# Esperar a que MariaDB arranque
until mysqladmin ping --silent; do
    echo "⏳ Esperando a MariaDB..."
    sleep 2
done

# Configurar DB y usuario usando root con contraseña
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Detener instancia temporal
kill $MYSQL_PID
wait $MYSQL_PID

echo "✅ MariaDB lista"
exec mysqld --user=mysql --console
