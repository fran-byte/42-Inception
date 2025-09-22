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

mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock --skip-log-error &
MYSQL_PID=$!

sleep 3

mysql -S /tmp/mysql.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass';
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
EOF

kill $MYSQL_PID
wait $MYSQL_PID

echo "✅ Starting MariaDB..."
exec mysqld --user=mysql --console
