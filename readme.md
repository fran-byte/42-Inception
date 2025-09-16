# 🚀 Inception Project - Dockerized Infrastructure

## 📋 Índice
1. [Preparación del Entorno](#-preparación-del-entorno)
2. [Estructura del Proyecto](#-estructura-del-proyecto)
3. [Descripción de Carpetas y Archivos](#-descripción-de-carpetas-y-archivos)
4. [Configuración de Dockerfiles](#-configuración-de-dockerfiles)
5. [Variables de Entorno](#-variables-de-entorno)
6. [Configuración de Docker Compose](#-configuración-de-docker-compose)
7. [Makefile](#-makefile)
8. [Configuración del Dominio](#-configuración-del-dominio)
9. [Pruebas y Validación](#-pruebas-y-validación)
10. [Parte Bonus](#-parte-bonus)

## 🧱 Preparación del Entorno

- **Máquina Virtual (Debian)**: Entorno aislado y controlado para garantizar consistencia en la configuración y evitar conflictos con el sistema principal.
- **[Instalación](doc/docker_install.md) de Docker y Docker Compose**: Herramientas esenciales para la creación y gestión de contenedores.
- **Estructura de Carpetas Base**: Organización clara del proyecto para separar configuraciones, servicios y secretos.

```bash
mkdir -p inception/srcs/requirements/{nginx,wordpress,mariadb}
mkdir -p inception/secrets
touch inception/Makefile inception/srcs/docker-compose.yml inception/srcs/.env
```

## 📁 Estructura del Proyecto

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
│       │   └── conf/
│       │   │   └── nginx.conf
│       │   └── tools/
│       │       └── certs.sh
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── tools/
│       │       └── script.sh
│       └── mariadb/
│           ├── Dockerfile
│           └── tools/
│               └── script.sh
```

## 📋 Descripción de Carpetas y Archivos

### 🔹 `requirements/nginx/`

**Propósito:** Contenedor que actúa como **puerta de entrada** a la infraestructura, sirviendo contenido por HTTPS (TLSv1.2 o TLSv1.3).

**Contenido:**
- `Dockerfile`: Construye la imagen de NGINX desde Alpine o Debian.
- `conf/nginx.conf`: Configuración personalizada de NGINX (incluye certificados, proxy hacia WordPress, etc.).
- `tools/`: Scripts para generar certificados TLS autofirmados o configuraciones adicionales.
- `.dockerignore`: Excluye archivos innecesarios al construir la imagen.

### 🔹 `requirements/wordpress/`

**Propósito:** Contenedor que ejecuta WordPress con **PHP-FPM**, sin NGINX.

**Contenido:**
- `Dockerfile`: Instala WordPress y PHP-FPM desde Alpine o Debian.
- `conf/`: Configuración de PHP-FPM (opcional).
- `tools/`: Scripts para inicializar WordPress o configurar plugins.
- `.dockerignore`: Excluye archivos innecesarios.

> Este contenedor es servido por NGINX mediante proxy y no expone puertos públicos.

### 🔹 `requirements/mariadb/`

**Propósito:** Contenedor que ejecuta **MariaDB**, la base de datos de WordPress.

**Contenido:**
- `Dockerfile`: Instala y configura MariaDB desde Alpine o Debian.
- `conf/`: Configuración personalizada de MariaDB.
- `tools/`: Scripts para crear usuarios, bases de datos, etc.
- `.dockerignore`: Excluye archivos innecesarios.

> Se deben crear dos usuarios en la base de datos, uno de ellos administrador (sin usar nombres como 'admin', 'administrator', etc.).

### 🔹 `secrets/`

**Propósito:** Almacenar **credenciales sensibles** que no deben estar en los Dockerfiles ni en el repositorio.

**Contenido:**
- `db_password.txt`: Contraseña del usuario de la base de datos.
- `db_root_password.txt`: Contraseña del usuario root de MariaDB.
- `credentials.txt`: Otras credenciales necesarias.

> Estos archivos deben estar excluidos del control de versiones (`.gitignore`) y se utilizan con Docker secrets.

### 🔹 `srcs/`

**Propósito:** Carpeta principal de configuración del proyecto.

**Contenido:**
- `.env`: Archivo con variables de entorno (dominio, usuarios, contraseñas, etc.).
- `docker-compose.yml`: Define los servicios, redes, volúmenes y cómo se construyen los contenedores.
- `Makefile`: Automatiza la construcción y despliegue del proyecto.
- `requirements/`: Subcarpeta con los tres servicios obligatorios y posibles bonus.

### 🔸 `Makefile`

**Propósito:** Automatización de procesos.

**Cometido:**
- Ejecuta comandos complejos de Docker Compose con una sola instrucción.
- Garantiza consistencia en el despliegue (ej: `make build`, `make up`).

### 🔸 `docker-compose.yml`

**Propósito:** Orquestación de contenedores.

**Cometido:**
- Define servicios, volúmenes, redes y variables de entorno.
- Establece dependencias entre contenedores y políticas de reinicio.

### 🔸 `.env`

**Propósito:** Gestión centralizada de configuraciones variables.

**Cometido:**
- Almacena valores como dominios, usuarios y contraseñas sin hardcodear.
- Permite portabilidad y seguridad al evitar datos sensibles en el código.

### 🔸 Volúmenes Docker

**Propósito:** Persistencia de datos.

**Cometido:**
- `wordpress_volume`: Guarda archivos del sitio (themes, plugins, uploads).
- `mariadb_volume`: Almacena la base de datos persistentemente.

### 🔸 Red Docker Personalizada

**Propósito:** Aislamiento y comunicación segura entre contenedores.

**Cometido:**
- Permite que los contenedores se comuniquen por nombres de servicio.
- Aísla la infraestructura de redes externas no autorizadas.

## 🐳 Configuración de Dockerfiles

- **NGINX**: Configurado con TLSv1.2/1.3, puerto 443, sin uso de `tail -f` o bucles infinitos.
- **WordPress**: Configurado con PHP-FPM, sin servidor web propio.
- **MariaDB**: Configurado con usuarios personalizados y base de datos.

Cada Dockerfile debe usar como base `alpine` o `debian`, y no se permiten imágenes preconstruidas como `wordpress:latest`.

## 🔐 Variables de Entorno

Crear un archivo `.env` con variables como:

```env
DOMAIN_NAME=frromero.42.fr
MYSQL_ROOT_PASSWORD=...
MYSQL_USER=...
MYSQL_PASSWORD=...
MYSQL_DATABASE=wordpress
```

## 🧩 Configurar `docker-compose.yml`

- Define los tres servicios: `nginx`, `wordpress`, `mariadb`.
- Utiliza `build:` para cada servicio, apuntando a su carpeta correspondiente.
- Define volúmenes para persistencia de datos:
  - Volumen para la base de datos MariaDB.
  - Volumen para los archivos de WordPress.
- Define una red personalizada para comunicación entre contenedores.
- Configura `restart: always` para cada contenedor.

## 🛠️ Crear el Makefile

El Makefile debe construir todo el entorno con:

```makefile
all:
	docker-compose --env-file srcs/.env -f srcs/docker-compose.yml up --build -d
```

## 🌐 Configurar el Dominio

El dominio debe ser `frromero.42.fr` apuntando a la IP local. Se puede simular editando el archivo `/etc/hosts`:

```bash
echo "127.0.0.1 frromero.42.fr" | sudo tee -a /etc/hosts
```

## 🧪 Pruebas y Validación

Verificar que:
- NGINX responde correctamente por HTTPS.
- WordPress se conecta adecuadamente a MariaDB.
- Los volúmenes persisten los datos correctamente.
- Los contenedores se reinician automáticamente en caso de fallo.

## 🎁 Parte Bonus (Opcional)

Solo se evaluará si la parte obligatoria funciona perfectamente:

- **Redis cache**: Para mejorar el rendimiento de WordPress mediante caching.
- **FTP server**: Para gestión externa de archivos.
- **Sitio estático**: Desarrollado en cualquier lenguaje excepto PHP.
- **Adminer**: Interfaz web para gestión de bases de datos.
- **Servicio personalizado**: Cualquier servicio adicional que se considere útil, debiendo justificarse durante la defensa.

Para la parte bonus, se permite abrir puertos adicionales según sea necesario.
