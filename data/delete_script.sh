#!/bin/bash

# Crear directorios
mkdir -p secrets
mkdir -p srcs/requirements/nginx/conf
mkdir -p srcs/requirements/nginx/tools
mkdir -p srcs/requirements/wordpress/tools
mkdir -p srcs/requirements/mariadb/tools

# Crear archivos vacíos
touch Makefile
touch secrets/db_password.txt
touch secrets/db_root_password.txt
touch srcs/.env
touch srcs/docker-compose.yml
touch srcs/requirements/nginx/Dockerfile
touch srcs/requirements/nginx/conf/nginx.conf
touch srcs/requirements/nginx/tools/certs.sh
touch srcs/requirements/wordpress/Dockerfile
touch srcs/requirements/wordpress/tools/script.sh
touch srcs/requirements/mariadb/Dockerfile

echo "Estructura creada correctamente ✅"
