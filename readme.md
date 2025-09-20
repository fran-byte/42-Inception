# 🚀 Inception Project - Dockerized Infrastructure

[Resources](doc/resources.md)

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

## 0. Requisitos del Proyecto Inception:


| Categoría                     | Requisitos                                                                                                                                                                                                                               |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Entorno**                   | - Todo debe hacerse en una **Máquina Virtual**.<br>- Se debe usar **Docker Compose**.<br>- Cada servicio en un **contenedor dedicado**.<br>- Imágenes basadas en **Alpine** o **Debian** (última versión estable –1).                    |
| **Estructura de archivos**    | - Todos los archivos en una carpeta `srcs/`.<br>- Un **Makefile** en la raíz que construya todo (llamando a `docker-compose.yml`).<br>- Un **Dockerfile por servicio** (no usar imágenes prehechas de DockerHub, salvo Alpine/Debian).   |
| **Servicios obligatorios**    | - Contenedor **NGINX** (TLSv1.2 o TLSv1.3, puerto 443).<br>- Contenedor **WordPress con php-fpm** (sin nginx).<br>- Contenedor **MariaDB** (sin nginx).                                                                                  |
| **Volúmenes**                 | - Uno para la base de datos de WordPress.<br>- Otro para los archivos del sitio WordPress.                                                                                                                                               |
| **Redes**                     | - Usar una **docker-network** definida en `docker-compose.yml`.<br>- Prohibido `network: host`, `--link` o `links:`.                                                                                                                     |
| **Políticas de ejecución**    | - Los contenedores deben **reiniciarse automáticamente** en caso de fallo.<br>- Prohibido usar bucles infinitos (`tail -f`, `sleep infinity`, `while true`, etc.).<br>- Seguir buenas prácticas con **PID 1** en Docker.                 |
| **Base de datos**             | - En la BD de WordPress debe haber **2 usuarios**:<br>   • Uno administrador (**NO** puede contener "admin", "administrator", etc.).                                                                                                     |
| **Dominios y paths**          | - Los volúmenes deben estar en `/home/login/data/` (reemplazar `login` por tu usuario).<br>- Debes configurar un dominio `login.42.fr` → tu IP local.                                                                                    |
| **Restricciones adicionales** | - Prohibido usar la etiqueta `latest` en imágenes.<br>- No guardar **contraseñas en Dockerfiles**.<br>- Debes usar **variables de entorno** (recomendado `.env` y/o `docker secrets`).                                                   |
| **Entrada a la infra**        | - El único punto de entrada debe ser **NGINX** en el puerto 443 con TLSv1.2/1.3.                                                                                                                                                         |
| **Bonus (opcional)**          | - Redis cache para WordPress.<br>- Servidor FTP vinculado al volumen de WordPress.<br>- Sitio estático (no PHP).<br>- Adminer.<br>- Otro servicio útil (con justificación).<br>⚠️ Solo se evalúan si la parte obligatoria está perfecta. |
| **Entrega y evaluación**      | - Subir el trabajo al repositorio Git.<br>- Se evaluará **solo lo que está en el repo**.<br>- Pueden pedir cambios pequeños durante la defensa.                                                                                          |

---




## 🧱 Preparación del Entorno

- **Máquina Virtual (Debian)**: Entorno aislado y controlado para garantizar consistencia en la configuración y evitar conflictos con el sistema principal.
- Corregir Error deVMX root mode. SOLUCIOÓN: `sudo rmmod kvm_intel`
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



---



## ✅ Verificación detallada de Nginx

| **Requisito del proyecto**         | **Cumplimiento** | **Explicación técnica completa** |
|-----------------------------------|------------------|----------------------------------|
| **Instalación manual**            | ✔️               | Usas la imagen base `debian:bookworm-slim`, lo que demuestra que no estás usando una imagen preconfigurada de Nginx. Luego instalas Nginx manualmente con `apt install -y nginx`, cumpliendo el requisito de instalación desde cero. |
| **HTTPS con SSL propio**          | ✔️               | Has generado tus propios certificados (`selfsigned.crt` y `selfsigned.key`) y los has copiado al contenedor en rutas estándar (`/etc/ssl/certs/` y `/etc/ssl/private/`). En `nginx.conf`, los usas correctamente con `ssl_certificate` y `ssl_certificate_key`. Esto habilita HTTPS sin depender de certificados externos. |
| **Redirección HTTP→HTTPS**        | ✔️               | En el bloque del servidor que escucha en el puerto 80, usas `return 301 https://$host$request_uri;`, lo que fuerza la redirección de todas las peticiones HTTP hacia HTTPS. Esto es obligatorio para asegurar que el sitio se sirva exclusivamente por HTTPS. |
| **Puerto 443 expuesto**           | ✔️               | En el `Dockerfile`, incluyes `EXPOSE 443`, lo que indica que el contenedor está preparado para recibir tráfico HTTPS. En `docker-compose.yml`, mapeas `"443:443"`, lo que permite que el tráfico externo llegue al contenedor. |
| **Comunicación con WordPress**    | ✔️               | En `nginx.conf`, usas `fastcgi_pass wordpress:9000;`, lo que indica que Nginx está configurado para enviar peticiones PHP al contenedor de WordPress a través del puerto 9000, donde debe estar corriendo PHP-FPM. También incluyes `SCRIPT_FILENAME`, que es esencial para que PHP-FPM sepa qué archivo ejecutar. |
| **Configuración personalizada**   | ✔️               | Has creado tu propio archivo `nginx.conf` y lo copias al contenedor con `COPY conf/nginx.conf /etc/nginx/nginx.conf`. El archivo está bien estructurado, incluye los bloques `server`, define `root`, `index`, y gestiona correctamente las peticiones PHP. Esto demuestra que no estás usando la configuración por defecto. |
| **Volumen compartido**            | ✔️               | En `docker-compose.yml`, montas el volumen `wordpress_data:/var/www/html` tanto en Nginx como en WordPress. Esto permite que Nginx sirva los archivos PHP que WordPress genera, y que ambos contenedores compartan el mismo sistema de archivos para el sitio web. |

---










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


---
---

¡Vamos allá, Fran! Aquí tienes un **chuletario esencial** para moverte con soltura tanto **dentro del contenedor MariaDB** como **dentro del cliente SQL**. Ideal para debuggear, verificar, y controlar tu entorno sin perder tiempo.

---

## 🐳 **Comandos fuera del contenedor (Docker)**

| Acción | Comando |
|-------|--------|
| Ver contenedores activos | `docker ps` |
| Ver todos los contenedores | `docker ps -a` |
| Entrar al contenedor MariaDB | `docker exec -it mariadb bash` |
| Ver logs del contenedor | `docker logs mariadb` |
| Parar el contenedor | `docker stop mariadb` |
| Reiniciar el contenedor | `docker restart mariadb` |
| Eliminar contenedor | `docker rm mariadb` |
| Ver redes | `docker network ls` |
| Ver volúmenes | `docker volume ls` |
| Inspeccionar volumen | `docker volume inspect srcs_db_data` |

---

## 🧠 **Comandos dentro del contenedor (cliente MariaDB)**

Una vez dentro del contenedor, accedes al cliente con:

```bash
mysql -u frromero -p
```

Y luego introduces la contraseña (`contraseña_de_usuario`).

---

### 📚 Comandos SQL básicos

| Acción | Comando SQL |
|--------|-------------|
| Ver bases de datos | `SHOW DATABASES;` |
| Usar una base de datos | `USE wordpress;` |
| Ver tablas | `SHOW TABLES;` |
| Ver usuarios | `SELECT user, host FROM mysql.user;` |
| Crear usuario | `CREATE USER 'nombre'@'%' IDENTIFIED BY 'clave';` |
| Crear base de datos | `CREATE DATABASE nombre;` |
| Dar permisos | `GRANT ALL PRIVILEGES ON nombre.* TO 'usuario'@'%';` |
| Ver permisos | `SHOW GRANTS FOR 'usuario'@'%';` |
| Eliminar usuario | `DROP USER 'usuario'@'%';` |
| Eliminar base de datos | `DROP DATABASE nombre;` |
| Salir del cliente | `exit` |

---

### 🔧 Tip extra: acceder como root

Si necesitas entrar como root (por ejemplo, para ver todo):

```bash
mysql -u root
```

(Si no hay contraseña configurada para root, entra directo. Si la hay, usa `-p` y escribe la clave.)
