#!/bin/bash

# Script de configuración para Proyecto Inception
# Todo en la raíz del proyecto

echo "Creando estructura para Inception en el directorio actual..."

# Verificar que estamos en el directorio correcto
if [ -f "Makefile" ] || [ -d "srcs" ] || [ -d "secrets" ]; then
    echo "Error: Ya existen archivos/directorios de Inception aquí"
    exit 1
fi

# Paso 1: Crear estructura de directorios
echo "Paso 1: Creando estructura de directorios..."

mkdir -p srcs/requirements/mariadb/conf
mkdir -p srcs/requirements/mariadb/tools
mkdir -p srcs/requirements/nginx/conf
mkdir -p srcs/requirements/nginx/tools
mkdir -p srcs/requirements/wordpress/conf
mkdir -p srcs/requirements/wordpress/tools
mkdir -p secrets

# SOLO crear el directorio data/ padre - los subdirectorios los creará Docker
mkdir -p data

echo "Estructura creada"

# Paso 2: Configurar permisos de seguridad
echo "Paso 2: Configurando permisos..."

chmod 700 secrets
chmod 755 data

echo "Permisos configurados"

# Paso 3: Crear archivos base vacíos
echo "Paso 3: Creando archivos base..."

# Crear Makefile vacío
touch Makefile

# Crear docker-compose.yml vacío
touch srcs/docker-compose.yml

# Crear .env vacío en srcs/
touch srcs/.env

# Crear Dockerfiles vacíos
touch srcs/requirements/mariadb/Dockerfile
touch srcs/requirements/nginx/Dockerfile
touch srcs/requirements/wordpress/Dockerfile

# Crear archivos de secrets vacíos
touch secrets/db_root_password.txt
touch secrets/db_password.txt
touch secrets/wordpress_password.txt

echo "Archivos base creados"

# Paso 4: Mostrar estructura final
echo "Paso 4: Estructura final creada:"
tree -a

echo "Configuración completada."
echo "Nota: Los directorios data/wordpress_data y data/mariadb_data se crearán automáticamente al ejecutar: docker-compose -f srcs/docker-compose.yml up -d"
