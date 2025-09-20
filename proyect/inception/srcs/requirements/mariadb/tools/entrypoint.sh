#!/bin/sh
set -e

echo "🔧 Checking MariaDB initialization..."

# Si falta alguna tabla del sistema mysql, reinstalar completamente
if [ ! -f /var/lib/mysql/mysql/user.frm ] || [ ! -f /var/lib/mysql/mysql/plugin.frm ]; then
    echo "📦 Re-initializing MariaDB system tables..."
    rm -rf /var/lib/mysql/*
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "✅ System tables re-initialized"
else
    echo "✅ System tables already exist"
fi

# Corregir permisos
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

echo "✅ Starting MariaDB..."
exec mysqld --user=mysql --console
