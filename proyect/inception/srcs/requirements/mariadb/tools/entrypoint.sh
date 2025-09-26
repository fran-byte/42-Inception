#!/bin/sh
set -e

echo "🔧 Inicializando MariaDB..."

# Leer secrets desde el volumen montado
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/wp_to_db_user_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wp_to_db_user}

# Crear directorios y permisos
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Si la DB no existe, inicializamos y configuramos usuarios
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "📦 Creando las tablas del sistema..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "🔑 Configurando root y usuarios..."
    mysqld --user=mysql --skip-networking &
    MYSQL_PID=$!
    until mysqladmin ping --silent; do
        sleep 2
    done

    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- 🧹 Eliminar usuarios no válidos
DELETE FROM mysql.user
WHERE User NOT IN ('${MYSQL_USER}', 'root', 'mysql', 'mariadb.sys')
  OR User = ''
  OR Host = '';

FLUSH PRIVILEGES;
EOF

    kill $MYSQL_PID
    wait $MYSQL_PID
fi

echo "✅ MariaDB lista, iniciando servicio..."
exec mysqld_safe
