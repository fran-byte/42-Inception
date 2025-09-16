
## 🚀 Instalando Docker en Debian (VM)

### ✅ Paso 1: Actualiza tu sistema

```bash
sudo apt update
sudo apt upgrade -y
```

---

### ✅ Paso 2: Instala paquetes necesarios

```bash
sudo apt install ca-certificates curl gnupg lsb-release -y
```

---

### ✅ Paso 3: Crea el directorio para la clave GPG

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```
- Crea el directorio /etc/apt/keyrings con permisos seguros (0755).

- Este directorio se usa para guardar claves GPG que verifican la autenticidad de los paquetes descargados desde repositorios externos (como el de Docker). Es una práctica moderna y más segura que usar /etc/apt/trusted.gpg.
- 
---

### ✅ Paso 4: Descarga la clave GPG de Docker

Usamos `wget` para evitar errores con `curl`:

```bash
wget https://download.docker.com/linux/ubuntu/gpg -O docker.gpg
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg docker.gpg
```
- Descarga la clave pública de Docker desde su servidor oficial.

- gpg --dearmor : Convierte la clave desde formato ASCII (texto plano) a formato binario (.gpg) que APT puede usar.

 - Cuando agregas el repositorio de Docker, APT necesita verificar que los paquetes provienen realmente de Docker Inc. Esta clave permite esa verificación.

---

### ✅ Paso 5: Agrega el repositorio oficial de Docker

Como estás en Debian (y Trixie aún no está soportado oficialmente), usamos el repositorio de **Bookworm**:

```bash
echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  bookworm stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

### ✅ Paso 6: Instala Docker

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
Aqui se instala también Docker Compose, pero en su versión moderna como plugin oficial del CLI de Docker.
---

### ✅ Paso 7: Verifica que Docker funciona

```bash
sudo docker run hello-world
```

Si ves el mensaje “Hello from Docker!”, ¡todo está funcionando correctamente!


---

---



## 🧱 **1. Preparación del entorno**
- Crea una **máquina virtual** (VM) Linux.
- Instala **Docker** y **Docker Compose**.
- Crea la estructura de carpetas base:
  ```bash
  mkdir -p inception/srcs/requirements/{nginx,wordpress,mariadb}
  mkdir -p inception/secrets
  touch inception/Makefile inception/srcs/docker-compose.yml inception/srcs/.env
  ```

---

## 📁 **2. Estructura del proyecto**
```
inception/
├── Makefile
├── secrets/
│   ├── db_password.txt
│   └── db_root_password.txt
├── srcs/
│   ├── .env
│   ├── docker-compose.yml
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/nginx.conf
│       ├── wordpress/
│       │   └── Dockerfile
│       └── mariadb/
│           └── Dockerfile
```

---

## 🐳 **3. Crear los Dockerfiles**
- **NGINX**: con TLSv1.2/1.3, puerto 443, sin `tail -f`.
- **WordPress**: con PHP-FPM, sin NGINX.
- **MariaDB**: con configuración de usuarios y base de datos.

Cada Dockerfile debe usar como base `alpine` o `debian`, y **no puedes usar imágenes preconstruidas** como `wordpress:latest`.

---

## 🔐 **4. Variables de entorno**
- Crea un archivo `.env` con variables como:
  ```env
  DOMAIN_NAME=francisco.42.fr
  MYSQL_ROOT_PASSWORD=...
  MYSQL_USER=...
  MYSQL_PASSWORD=...
  MYSQL_DATABASE=wordpress
  ```

---

## 🧩 **5. Configurar `docker-compose.yml`**
- Define los tres servicios: `nginx`, `wordpress`, `mariadb`.
- Usa `build:` para cada uno, apuntando a su carpeta.
- Define volúmenes:
  - Uno para la base de datos.
  - Otro para los archivos de WordPress.
- Define una red personalizada.
- Configura `restart: always` para cada contenedor.

---

## 🛠️ **6. Crear el Makefile**
- El Makefile debe construir todo el entorno con:
  ```makefile
  all:
  	docker-compose --env-file srcs/.env -f srcs/docker-compose.yml up --build -d
  ```

---

## 🌐 **7. Configurar el dominio**
- El dominio debe ser `francisco.42.fr` apuntando a tu IP local.
- Puedes simular esto en `/etc/hosts`:
  ```bash
  echo "127.0.0.1 francisco.42.fr" | sudo tee -a /etc/hosts
  ```

---

## 🧪 **8. Pruebas y validación**
- Verifica que:
  - NGINX responde por HTTPS.
  - WordPress se conecta a MariaDB.
  - Los volúmenes persisten datos.
  - Los contenedores se reinician automáticamente.

---

## 🎁 **9. Bonus (opcional)**
Solo si la parte obligatoria funciona perfectamente:
- Redis cache para WordPress.
- FTP server.
- Sitio estático (no PHP).
- Adminer.
- Otro servicio útil que puedas justificar.

---


