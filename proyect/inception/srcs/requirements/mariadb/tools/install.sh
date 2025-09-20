#!/bin/bash
set -e

echo "🔧 Configurando MariaDB durante el build..."

# Inicializar la base de datos
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Iniciar MariaDB temporalmente para configurarlo
mysqld_safe --user=mysql --skip-networking &

# Esperar a que esté listo
sleep 5

# Configurar usuarios y bases de datos (usando valores por defecto durante el build)
# NOTA: Los secrets no están disponibles durante el build, así que usamos valores temporales
# Estos serán sobrescritos en el primer inicio con los valores reales de los secrets

cat <<SQL > /tmp/init.sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'temp_root_password';
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'temp_password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
SQL

# Ejecutar el script de configuración
mysql -uroot < /tmp/init.sql

# Detener el servidor temporal
killall mysqld
sleep 3

echo "✅ Configuración de MariaDB completada durante el build."
