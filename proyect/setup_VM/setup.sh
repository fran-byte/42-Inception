#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Iniciando configuración automática de VM Debian...${NC}"

# Verificar sudo
if ! sudo -n true 2>/dev/null; then
    echo -e "${RED}❌ Error: Necesitas privilegios de sudo${NC}"
    exit 1
fi

### ✅ Paso 1: Actualizar sistema
echo -e "${YELLOW}📦 Paso 1/8: Actualizando sistema...${NC}"
sudo apt update
sudo apt upgrade -y
echo -e "${GREEN}✅ Sistema actualizado${NC}"

### ✅ Paso 2: Instalar paquetes base (SIN certificados extras)
echo -e "${YELLOW}📦 Paso 2/8: Instalando paquetes base...${NC}"
sudo apt install ca-certificates curl wget git vim htop net-tools tree unzip -y
echo -e "${GREEN}✅ Paquetes base instalados${NC}"

### ✅ Paso 3: Instalar Docker desde repositorios DEBIAN (NO Docker Hub)
echo -e "${YELLOW}🐳 Paso 3/8: Instalando Docker...${NC}"
sudo apt install -y docker.io docker-compose
echo -e "${GREEN}✅ Docker instalado${NC}"

### ✅ Paso 4: Configurar usuario Docker
echo -e "${YELLOW}👥 Paso 4/8: Configurando usuario para Docker...${NC}"
sudo usermod -aG docker $USER
echo -e "${GREEN}✅ Usuario agregado al grupo Docker${NC}"

### ✅ Paso 5: Configurar dominio local
echo -e "${YELLOW}🌐 Paso 5/8: Configurando dominio local...${NC}"
if ! grep -q "frromero.42.fr" /etc/hosts; then
    echo "127.0.0.1 frromero.42.fr" | sudo tee -a /etc/hosts
    echo -e "${GREEN}✅ Dominio local configurado${NC}"
else
    echo -e "${BLUE}ℹ  Dominio ya existente${NC}"
fi

### ✅ Paso 6: Configurar SSH
echo -e "${YELLOW}🔒 Paso 6/8: Configurando SSH...${NC}"
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
echo -e "${GREEN}✅ SSH configurado${NC}"

### ✅ Paso 7: Sincronizar hora
echo -e "${YELLOW}🕒 Paso 7/8: Sincronizando hora...${NC}"
sudo apt install -y ntpsec-ntpdate
sudo sntp -P no -r pool.ntp.org
echo -e "${GREEN}✅ Hora sincronizada${NC}"

### ✅ Paso 8: Verificaciones finales
echo -e "${YELLOW}🔍 Paso 8/8: Verificaciones finales...${NC}"
echo -e "${GREEN}✅ Docker: $(docker --version)${NC}"
echo -e "${GREEN}✅ Docker Compose: $(docker compose version)${NC}"

### ✅ PROBAR DOCKER SIN CERTIFICADOS EXTRA
echo -e "${YELLOW}🧪 Probando Docker con Alpine...${NC}"
if docker pull alpine:3.18; then
    echo -e "${GREEN}🎉 ¡ÉXITO! Docker funciona correctamente${NC}"
else
    echo -e "${RED}❌ Error: Revisa conexión a internet${NC}"
fi

echo -e "${GREEN}🎉 ¡Configuración completada!${NC}"
echo -e "${YELLOW}📋 Ejecuta: ${BLUE}newgrp docker${YELLOW} o reinicia sesión${NC}"
