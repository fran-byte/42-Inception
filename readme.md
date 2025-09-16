## 0 **Resources**
- Apartado de [recursos](doc/resources.md)


## 🧱 **1. Preparación del entorno**
- Crea una **máquina virtual** (VM) usaremos debian.
- [Instala](doc/docker_install.md) **Docker** y **Docker Compose**.
- Crea la estructura de carpetas base:
  ```bash
  mkdir -p inception/srcs/requirements/{nginx,wordpress,mariadb}
  mkdir -p inception/secrets
  touch inception/Makefile inception/srcs/docker-compose.yml inception/srcs/.env
  ```


## 📁 **Estructura del proyecto y contenido por carpeta**

---

### 🔹 `requirements/nginx/`

**Propósito:** Contenedor que actúa como **puerta de entrada** a tu infraestructura, sirviendo contenido por HTTPS (TLSv1.2 o TLSv1.3).

**Contenido típico:**
- `Dockerfile`: construye la imagen de NGINX desde Alpine o Debian.
- `conf/nginx.conf`: configuración personalizada de NGINX (incluye certificados, proxy hacia WordPress, etc.).
- `tools/` (opcional): scripts para generar certificados TLS autofirmados o configuraciones adicionales.
- `.dockerignore`: para excluir archivos innecesarios al construir la imagen.

---

### 🔹 `requirements/wordpress/`

**Propósito:** Contenedor que ejecuta WordPress con **PHP-FPM**, sin NGINX.

**Contenido típico:**
- `Dockerfile`: instala WordPress y PHP-FPM desde Alpine o Debian.
- `conf/` (opcional): configuración de PHP-FPM.
- `tools/` (opcional): scripts para inicializar WordPress o configurar plugins.
- `.dockerignore`: para excluir archivos innecesarios.

> Este contenedor será **servido por NGINX** mediante proxy, no debe tener servidor web propio.

---

### 🔹 `requirements/mariadb/`

**Propósito:** Contenedor que ejecuta **MariaDB**, la base de datos de WordPress.

**Contenido típico:**
- `Dockerfile`: instala y configura MariaDB desde Alpine o Debian.
- `conf/`: configuración personalizada de MariaDB (por ejemplo, `my.cnf`).
- `tools/`: scripts para crear usuarios, bases de datos, etc.
- `.dockerignore`: para excluir archivos innecesarios.

> Debes crear **dos usuarios** en la base de datos, uno de ellos administrador (sin usar nombres como `admin`, `administrator`, etc.).

---

### 🔹 `secrets/`

**Propósito:** Almacenar **credenciales sensibles** que no deben estar en los Dockerfiles ni en el repositorio.

**Contenido típico:**
- `db_password.txt`: contraseña del usuario de la base de datos.
- `db_root_password.txt`: contraseña del usuario root de MariaDB.
- `credentials.txt`: otras credenciales necesarias (por ejemplo, para WordPress).

> Estos archivos deben estar **excluidos del control de versiones** (`.gitignore`) y pueden usarse con Docker secrets.

---

### 🔹 `srcs/`

**Propósito:** Carpeta principal de configuración del proyecto.

**Contenido típico:**
- `.env`: archivo con variables de entorno (dominio, usuarios, contraseñas, etc.).
- `docker-compose.yml`: define los servicios, redes, volúmenes y cómo se construyen los contenedores.
- `Makefile`: automatiza la construcción y despliegue del proyecto.
- `requirements/`: subcarpeta con los tres servicios obligatorios (nginx, wordpress, mariadb) y posibles bonus.




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

