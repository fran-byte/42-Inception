#!/bin/bash
set -e

echo "🔧 Inicializando MariaDB durante el build..."

# Crear directorios y permisos
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

# Inicializar la base de datos (sin usuarios ni contraseñas)
mysql_install_db --user=mysql --datadir=/var/lib/mysql

echo "✅ MariaDB listo durante el build."
