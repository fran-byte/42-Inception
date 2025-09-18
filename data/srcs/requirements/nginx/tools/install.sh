#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export APT_OPTIONS="-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"

echo "🔧 Actualizando paquetes..."
apt update

echo "📦 Instalando Nginx y wget..."
apt install -y $APT_OPTIONS nginx wget

echo "📄 Descargando fastcgi_params..."
wget https://raw.githubusercontent.com/nginx/nginx/master/conf/fastcgi_params -O /etc/nginx/fastcgi_params

echo "📄 Descargando mime.types..."
wget https://raw.githubusercontent.com/nginx/nginx/master/conf/mime.types -O /etc/nginx/mime.types

echo "🧹 Limpiando caché de APT..."
apt clean && rm -rf /var/lib/apt/lists/*

echo "🚀 Iniciando Nginx en primer plano..."
nginx -g "daemon off;"
