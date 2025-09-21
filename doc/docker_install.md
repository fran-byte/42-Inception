## 🚀 Instalando entorno (script)

---

### **1️⃣ Encabezado del script**

```bash
#!/bin/bash
```

* Esto indica que el script debe ejecutarse con **Bash**, el intérprete de comandos de Linux.

---

### **2️⃣ Definición de colores para la salida**

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
```

* Define variables para usar colores en la salida por terminal.
* `\033[` inicia un **código de escape ANSI** para colores.
* `NC` es "No Color", para resetear el color al valor por defecto.

---

### **3️⃣ Mensajes iniciales**

```bash
echo -e "${GREEN}🚀 Iniciando configuración automática de VM Debian...${NC}"
echo -e "${BLUE}Usuario: $(whoami)${NC}"
echo -e "${BLUE}Sudo disponible: $(sudo -n true 2>/dev/null && echo '✅' || echo '❌')${NC}"
```

* `echo -e` permite interpretar secuencias como colores.
* `$(whoami)` obtiene el usuario actual.
* `sudo -n true` verifica si el usuario puede ejecutar `sudo` sin contraseña.
* Muestra con ✅ o ❌ si `sudo` funciona.

---

### **4️⃣ Verificación de permisos sudo**

```bash
if ! sudo -n true 2>/dev/null; then
    echo -e "${RED}❌ Error: Necesitas tener privilegios de sudo para ejecutar este script${NC}"
    echo -e "${YELLOW}Por favor ejecuta: sudo echo 'Test sudo' y luego vuelve a ejecutar el script${NC}"
    exit 1
fi
```

* Si el usuario no tiene permisos de sudo, el script se detiene (`exit 1`) y muestra instrucciones.

---

### **5️⃣ Paso 1: Actualizar sistema**

```bash
sudo apt update
sudo apt upgrade -y
```

* `apt update`: actualiza la lista de paquetes disponibles.
* `apt upgrade -y`: instala las actualizaciones disponibles automáticamente (`-y` evita preguntar).

---

### **6️⃣ Paso 2: Instalar paquetes base**

```bash
sudo apt install ca-certificates curl gnupg lsb-release wget openssh-server git vim htop net-tools tree unzip -y
```

* Instala herramientas básicas para administración y desarrollo:

  * `ca-certificates`: certificados SSL.
  * `curl`, `wget`: descargar archivos.
  * `gnupg`: gestionar claves GPG.
  * `lsb-release`: info del sistema.
  * `openssh-server`: servidor SSH.
  * `git`, `vim`, `htop`, `net-tools`, `tree`, `unzip`.

---

### **7️⃣ Paso 2.5: Reinstalar certificados raíz**

```bash
sudo apt install --reinstall ca-certificates -y
sudo update-ca-certificates
```

* Asegura que los certificados raíz del sistema estén actualizados para TLS/HTTPS.

---

### **8️⃣ Paso 2.7: Añadir certificados raíz adicionales**

```bash
sudo wget -q -O /usr/local/share/ca-certificates/lets-encrypt-r3.crt https://letsencrypt.org/certs/lets-encrypt-r3.pem
sudo wget -q -O /usr/local/share/ca-certificates/cloudflare-ecc-ca-3.crt https://developers.cloudflare.com/ssl/static/trust/certificates/cloudflare-ecc-ca-3.pem
sudo update-ca-certificates
```

* Añade certificados de **Let's Encrypt** y **Cloudflare ECC CA-3**.
* `update-ca-certificates` registra estos nuevos certificados en el sistema.

---

### **9️⃣ Paso 2.8: Configuración específica para Cloudflare R2**

* **Función `install_cloudflare_r2_cert`**:

  1. Intenta obtener el certificado TLS directamente desde el servidor Cloudflare R2 usando `openssl s_client`.
  2. Extrae la cadena de certificados (`awk '/BEGIN CERTIFICATE/ ...`).
  3. Separa certificados individuales con `csplit`.
  4. Copia el certificado raíz a `/usr/local/share/ca-certificates/`.
  5. Configura Docker para usar este certificado.
  6. Si falla, descarga certificados alternativos conocidos (`DigiCertGlobalRootG2`, `ISRG Root X1`).

* Después se llama a la función y se informa si se usó el método principal o alternativo.

---

### **10️⃣ Paso 2.6: Verificar conexión TLS con Docker Hub**

```bash
if curl -s https://registry-1.docker.io/v2/ > /dev/null; then ...
```

* Usa `curl` para asegurarse de que el sistema puede conectarse de forma segura a Docker Hub.
* Mensajes de error indican posibles problemas con hora, certificados o red.

---

### **11️⃣ Sincronizar hora**

```bash
sudo apt install ntpsec-ntpdate -y
sudo sntp -P no -r pool.ntp.org
```

* Instala `ntpsec-ntpdate` para sincronizar hora con servidores NTP.
* `sntp` actualiza la hora del sistema.

---

### **12️⃣ Reiniciar Docker para aplicar certificados**

```bash
sudo systemctl restart docker
```

* Reinicia Docker para que reconozca los certificados recién instalados.

---

### **13️⃣ Paso 3: Configurar directorio para claves GPG**

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

* Crea el directorio `/etc/apt/keyrings` para almacenar claves de repositorios de manera segura.

---

### **14️⃣ Paso 4: Descargar clave GPG de Docker**

```bash
wget -q https://download.docker.com/linux/ubuntu/gpg -O docker.gpg
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg docker.gpg
rm -f docker.gpg
```

* Descarga la clave GPG de Docker y la convierte a formato compatible con `apt`.

---

### **15️⃣ Paso 5: Agregar repositorio Docker**

```bash
DEBIAN_VERSION=$(lsb_release -cs)
# Ajusta bookworm si la versión es trixie o sid
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $DEBIAN_VERSION stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

* Determina la versión de Debian y añade el repositorio oficial de Docker.

---

### **16️⃣ Paso 6: Instalar Docker y Docker Compose**

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

* Instala el motor Docker y sus plugins, incluyendo **Docker Compose**.

---

### **17️⃣ Paso 7: Configurar usuario para Docker**

```bash
sudo usermod -aG docker $USER
```

* Añade el usuario actual al grupo `docker` para poder usar Docker sin `sudo`.

---

### **18️⃣ Paso 8: Configurar SSH**

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

* Activa y arranca el servicio SSH automáticamente al inicio.

---

### **19️⃣ Paso 9: Configurar dominio local**

```bash
if ! grep -q "frromero.42.fr" /etc/hosts; then
    echo "127.0.0.1 frromero.42.fr" | sudo tee -a /etc/hosts
fi
```

* Añade un dominio local en `/etc/hosts` apuntando a `127.0.0.1`.

---

### **20️⃣ Paso 10: Instalar herramientas adicionales**

```bash
sudo apt install python3 python3-pip python3-venv bash-completion tree -y
```

* Instala Python 3 y utilidades de desarrollo, además de herramientas de línea de comandos útiles.

---

### **21️⃣ Verificaciones finales**

* Comprueba:

  * Docker y Docker Compose.
  * SSH activo.
  * Dominio local configurado.
  * Usuario en grupo Docker.

---

### **22️⃣ Mensaje final**

```bash
echo -e "${GREEN}🎉 ¡Configuración completada!${NC}"
echo -e "${YELLOW}📋 Próximos pasos: ..."
```

* Indica pasos que el usuario debe hacer:

  * Cerrar sesión para actualizar grupos.
  * Probar Docker sin `sudo`.
  * Probar SSH y el dominio local.

---

✅ **Resumen general**:
Este script automatiza la configuración de una **VM Debian** para desarrollo con Docker:

1. Actualiza sistema y paquetes.
2. Gestiona certificados SSL (incluyendo Cloudflare R2).
3. Instala Docker y Compose, y configura usuario.
4. Configura SSH, dominio local y herramientas útiles.
5. Realiza verificaciones finales para asegurar que todo funciona.

---

