#!/bin/bash

# Si falla se detiene
set -e

# Cargando variables de entorno
if [ -f /secrets/.env ]; then
    export $(grep -v '^#' /secrets/.env | xargs)
else
    echo "Archivo .env no encontrado en /secrets"
    exit 1
fi

# Ejecutar comandos SQL al arrancar MariaDB
# Usamos un script de inicialización en lugar de lanzar dos veces el servidor

# Crear script SQL temporal
cat <<EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Lanzamos MariaDB con el script de inicialización
exec mysqld_safe --init-file=/tmp/init.sql
