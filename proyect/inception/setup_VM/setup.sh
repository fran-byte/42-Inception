#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Iniciando configuración automática de VM Debian...${NC}"
echo -e "${BLUE}Usuario: $(whoami)${NC}"
echo -e "${BLUE}Sudo disponible: $(sudo -n true 2>/dev/null && echo '✅' || echo '❌')${NC}"

# Verificar que tenemos sudo
if ! sudo -n true 2>/dev/null; then
    echo -e "${RED}❌ Error: Necesitas tener privilegios de sudo para ejecutar este script${NC}"
    echo -e "${YELLOW}Por favor ejecuta: sudo echo 'Test sudo' y luego vuelve a ejecutar el script${NC}"
    exit 1
fi

### ✅ Paso 1: Actualizar sistema
echo -e "${YELLOW}📦 Paso 1/10: Actualizando sistema...${NC}"
sudo apt update
sudo apt upgrade -y
echo -e "${GREEN}✅ Sistema actualizado${NC}"

### ✅ Paso 2: Instalar paquetes base
echo -e "${YELLOW}📦 Paso 2/10: Instalando paquetes base...${NC}"
sudo apt install ca-certificates curl gnupg lsb-release wget openssh-server git vim htop net-tools tree unzip -y
echo -e "${GREEN}✅ Paquetes base instalados${NC}"

### ✅ Paso 2.5: Reinstalar certificados raíz del sistema
echo -e "${YELLOW}🔐 Paso 2.5/10: Reinstalando certificados raíz del sistema...${NC}"
sudo apt install --reinstall ca-certificates -y
sudo update-ca-certificates
echo -e "${GREEN}✅ Certificados raíz actualizados${NC}"

### 🔐 Paso 2.7: Añadir certificados raíz globales necesarios para Docker Hub / Cloudflare
echo -e "${YELLOW}🌍 Paso 2.7/10: Añadiendo certificados raíz globales adicionales...${NC}"
# Let's Encrypt R3
sudo wget -q -O /usr/local/share/ca-certificates/lets-encrypt-r3.crt https://letsencrypt.org/certs/lets-encrypt-r3.pem
# Cloudflare ECC CA-3
sudo wget -q -O /usr/local/share/ca-certificates/cloudflare-ecc-ca-3.crt https://developers.cloudflare.com/ssl/static/trust/certificates/cloudflare-ecc-ca-3.pem

sudo update-ca-certificates
echo -e "${GREEN}✅ Certificados raíz globales instalados${NC}"

### 🔐 Paso 2.8: Resolver problema específico de certificados Cloudflare R2
echo -e "${YELLOW}🔐 Paso 2.8/10: Configurando certificados específicos para Cloudflare R2...${NC}"

# Función para instalar certificado específico de Cloudflare R2
install_cloudflare_r2_cert() {
    echo -e "${BLUE}ℹ  Obteniendo certificado actual de Cloudflare R2...${NC}"
    
    # Obtener cadena de certificados
    if echo -n | openssl s_client -connect docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com:443 \
        -servername docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com -showcerts 2>/dev/null | \
        awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' > /tmp/cloudflare_chain.pem 2>/dev/null; then
        
        # Separar certificados
        if command -v csplit >/dev/null 2>&1; then
            csplit -f cert- /tmp/cloudflare_chain.pem '/-----BEGIN CERTIFICATE-----/' '{*}' >/dev/null 2>&1
            ROOT_CERT=$(ls -tr cert-* 2>/dev/null | tail -1 2>/dev/null)
            
            if [ -f "$ROOT_CERT" ]; then
                # Instalar certificado
                sudo cp "$ROOT_CERT" /usr/local/share/ca-certificates/cloudflare_r2_root.crt
                sudo update-ca-certificates --fresh >/dev/null 2>&1
                
                # Configurar Docker
                sudo mkdir -p /etc/docker/certs.d/docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com
                sudo cp "$ROOT_CERT" /etc/docker/certs.d/docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com/ca.crt
                
                # Limpiar
                rm -f cert-* /tmp/cloudflare_chain.pem 2>/dev/null
                
                echo -e "${GREEN}✅ Certificado Cloudflare R2 instalado correctamente${NC}"
                return 0
            fi
        fi
    fi
    
    echo -e "${BLUE}⚠  No se pudo obtener certificado automáticamente, usando método alternativo...${NC}"
    
    # Método alternativo: descargar certificados conocidos de Cloudflare
    sudo wget -q -O /usr/local/share/ca-certificates/cloudflare_r2_alt1.crt https://cacerts.digicert.com/DigiCertGlobalRootG2.crt
    sudo wget -q -O /usr/local/share/ca-certificates/cloudflare_r2_alt2.crt https://letsencrypt.org/certs/isrgrootx1.pem
    
    sudo update-ca-certificates --fresh >/dev/null 2>&1
    echo -e "${GREEN}✅ Certificados alternativos instalados${NC}"
    return 1
}

# Ejecutar la instalación
if install_cloudflare_r2_cert; then
    echo -e "${GREEN}✅ Configuración Cloudflare R2 completada${NC}"
else
    echo -e "${YELLOW}⚠  Configuración Cloudflare R2 completada con método alternativo${NC}"
fi

### ✅ Paso 2.6: Verificar conexión TLS con Docker Hub
echo -e "${YELLOW}🔍 Paso 2.6/10: Verificando conexión segura con Docker Hub...${NC}"
if curl -s https://registry-1.docker.io/v2/ > /dev/null; then
    echo -e "${GREEN}✅ Conexión TLS con Docker Hub verificada${NC}"
else
    echo -e "${RED}❌ Error: No se pudo establecer conexión TLS con Docker Hub${NC}"
    echo -e "${YELLOW}ℹ Revisa la hora del sistema, certificados raíz o configuración de red/proxy${NC}"
fi

### 🔄 Sincronizar hora del sistema
echo -e "${YELLOW}🕒 Sincronizando hora del sistema...${NC}"
sudo apt install ntpsec-ntpdate -y
sudo sntp -P no -r pool.ntp.org
echo -e "${GREEN}✅ Hora sincronizada${NC}"

### 🔄 Reiniciar Docker para aplicar certificados
echo -e "${YELLOW}🔄 Reiniciando Docker para aplicar certificados...${NC}"
sudo systemctl restart docker
echo -e "${GREEN}✅ Docker reiniciado${NC}"

### ✅ Paso 3: Configurar directorio para claves GPG
echo -e "${YELLOW}🔑 Paso 3/10: Configurando claves GPG...${NC}"
sudo install -m 0755 -d /etc/apt/keyrings
echo -e "${GREEN}✅ Directorio de claves configurado${NC}"

### ✅ Paso 4: Descargar clave GPG de Docker
echo -e "${YELLOW}🐳 Paso 4/10: Instalando Docker...${NC}"
wget -q https://download.docker.com/linux/ubuntu/gpg -O docker.gpg
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg docker.gpg
rm -f docker.gpg
echo -e "${GREEN}✅ Clave GPG de Docker instalada${NC}"

### ✅ Paso 5: Agregar repositorio de Docker (para Debian Bookworm)
echo -e "${YELLOW}📦 Paso 5/10: Agregando repositorio Docker...${NC}"
DEBIAN_VERSION=$(lsb_release -cs)
if [ "$DEBIAN_VERSION" = "trixie" ] || [ "$DEBIAN_VERSION" = "sid" ]; then
    echo -e "${BLUE}⚠  Debian $DEBIAN_VERSION detectado, usando repositorio bookworm${NC}"
    DEBIAN_VERSION="bookworm"
fi
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $DEBIAN_VERSION stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo -e "${GREEN}✅ Repositorio Docker agregado para $DEBIAN_VERSION${NC}"

### ✅ Paso 6: Instalar Docker y Docker Compose
echo -e "${YELLOW}🐳 Paso 6/10: Instalando Docker Engine...${NC}"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo -e "${GREEN}✅ Docker instalado${NC}"

### ✅ Paso 7: Configurar Docker sin sudo para el usuario actual
echo -e "${YELLOW}👥 Paso 7/10: Configurando usuario para Docker...${NC}"
sudo usermod -aG docker $USER
echo -e "${GREEN}✅ Usuario $USER agregado al grupo Docker${NC}"

### ✅ Paso 8: Configurar SSH
echo -e "${YELLOW}🔒 Paso 8/10: Configurando SSH...${NC}"
sudo systemctl enable ssh
sudo systemctl start ssh
echo -e "${GREEN}✅ SSH configurado y activado${NC}"

### ✅ Paso 9: Configurar dominio local
echo -e "${YELLOW}🌐 Paso 9/10: Configurando dominio local...${NC}"
if ! grep -q "frromero.42.fr" /etc/hosts; then
    echo "127.0.0.1 frromero.42.fr" | sudo tee -a /etc/hosts
    echo -e "${GREEN}✅ Dominio local configurado${NC}"
else
    echo -e "${BLUE}ℹ  Dominio ya existente en /etc/hosts${NC}"
fi

### ✅ Paso 10: Instalar herramientas adicionales útiles
echo -e "${YELLOW}🛠  Paso 10/10: Instalando herramientas adicionales...${NC}"
sudo apt install python3 python3-pip python3-venv bash-completion tree -y
echo -e "${GREEN}✅ Herramientas adicionales instaladas${NC}"

### ✅ Verificaciones finales
echo -e "${YELLOW}🔍 Realizando verificaciones finales...${NC}"

if docker --version > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker: $(docker --version | head -n 1)${NC}"
else
    echo -e "${RED}❌ Docker no está instalado correctamente${NC}"
fi

if docker compose version > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker Compose: $(docker compose version | head -n 1)${NC}"
else
    echo -e "${RED}❌ Docker Compose no está instalado correctamente${NC}"
fi

if systemctl is-active --quiet ssh; then
    echo -e "${GREEN}✅ SSH: Activo y funcionando${NC}"
else
    echo -e "${RED}❌ SSH no está activo${NC}"
fi

if grep -q "frromero.42.fr" /etc/hosts; then
    echo -e "${GREEN}✅ Dominio: Configurado en /etc/hosts${NC}"
else
    echo -e "${RED}❌ Dominio no configurado${NC}"
fi

if groups $USER | grep -q docker; then
    echo -e "${GREEN}✅ Usuario: En grupo Docker${NC}"
else
    echo -e "${YELLOW}⚠  Usuario: Necesita re-login para grupo Docker${NC}"
fi

### ✅ Mensaje final
echo -e "${GREEN}🎉 ¡Configuración completada!${NC}"
echo -e "${YELLOW}📋 Próximos pasos:"
echo -e "  1. Cierra sesión y vuelve a entrar: ${BLUE}logout${YELLOW}"
echo -e "  2. Verifica Docker sin sudo: ${BLUE}docker run hello-world${YELLOW}"
echo -e "  3. Prueba SSH: ${BLUE}ssh $USER@localhost${YELLOW}"
echo -e "  4. Verifica el dominio: ${BLUE}ping -c 1 frromero.42.fr${NC}"
