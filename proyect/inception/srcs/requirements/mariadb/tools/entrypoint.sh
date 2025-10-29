#!/bin/sh
set -e

# --------------------------------------------------
# MariaDB Entrypoint: Starting container initialization
# --------------------------------------------------

# --------------------------------------------------
# Reading secrets from mounted volume
# --------------------------------------------------
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/wp_to_db_user_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wp_to_db_user}

# --------------------------------------------------
# Creating necessary directories and setting permissions
# --------------------------------------------------
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# --------------------------------------------------
# Initializing database if it does not exist
# --------------------------------------------------
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Creating system tables
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Creating initialization SQL script
    cat > /tmp/mariadb_init.sql << EOF
-- Secure root user
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Create application database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Create application user
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- Grant privileges
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Clean up invalid users
DELETE FROM mysql.user 
WHERE User NOT IN ('${MYSQL_USER}', 'root', 'mysql', 'mariadb.sys') 
  OR User = '' 
  OR Host = '';

-- Apply changes
FLUSH PRIVILEGES;
EOF

    # Start MariaDB temporarily with init script
    mysqld --user=mysql --init-file=/tmp/mariadb_init.sql &
    MYSQL_PID=$!

    # Wait for MariaDB to complete initialization
    sleep 10

    # Stop the temporary instance
    kill -TERM $MYSQL_PID 2>/dev/null
    wait $MYSQL_PID 2>/dev/null || true

    # Clean up
    rm -f /tmp/mariadb_init.sql
fi

# --------------------------------------------------
# Starting MariaDB service
# --------------------------------------------------
exec mysqld --user=mysql
