#!/bin/sh

# Entrypoint: main script executed when container starts

set -e

echo "---> Initializing MariaDB..."

# -----------------------------
# Read secrets from mounted volume
# -----------------------------
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/wp_to_db_user_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wp_to_db_user}

# -----------------------------
# Create directories and set permissions
# -----------------------------
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# -----------------------------
# Initialize database if it does not exist
# -----------------------------
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "---> Creating system tables..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # -----------------------------
    # Configure root and application users
    # -----------------------------
    echo "---> Configuring root and application users..."
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

-- 🧹 Remove invalid users
DELETE FROM mysql.user
WHERE User NOT IN ('${MYSQL_USER}', 'root', 'mysql', 'mariadb.sys')
  OR User = ''
  OR Host = '';

FLUSH PRIVILEGES;
EOF

    kill $MYSQL_PID
    wait $MYSQL_PID
fi

# -----------------------------
# Start MariaDB service
# -----------------------------
echo "✅ MariaDB ready, starting service..."
exec mysqld_safe
