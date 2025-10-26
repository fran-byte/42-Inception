#!/bin/sh
set -e

# -----------------------------
# MariaDB Entrypoint
# Main script executed when MariaDB container starts
# -----------------------------

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
    # Create initialization file for database setup
    # -----------------------------
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

    echo "---> Initializing database with users and permissions..."
    # Start MariaDB temporarily with init file
    mysqld --user=mysql --init-file=/tmp/mariadb_init.sql &
    MYSQL_PID=$!
    
    # Wait for MariaDB to complete initialization
    sleep 10
    
    # Stop the temporary instance
    kill -TERM $MYSQL_PID 2>/dev/null
    wait $MYSQL_PID 2>/dev/null || true
    
    # Clean up
    rm -f /tmp/mariadb_init.sql
    echo "---> Database initialization complete"
fi

echo "---> Starting MariaDB service..."
exec mysqld --user=mysql
