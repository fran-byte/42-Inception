# 🚀 Inception Project - Dockerized Infrastructure

[Resources](doc/resources.md)

---

## 📋 Índice

1. [Preparación del Entorno](#-preparación-del-entorno)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Descripción de Carpetas y Archivos](#descripción-de-carpetas-y-archivos)
4. [Configuración de Dockerfiles](#configuración-de-dockerfiles)
5. [Variables de Entorno](#variables-de-entorno)
6. [Configuración de Docker Compose](#configuración-de-docker-compose)
7. [Makefile](#makefile)
8. [Configuración del Dominio](#configuración-del-dominio)
9. [Pruebas y Validación](#pruebas-y-validación)
10. [Parte Bonus](#parte-bonus)
11. [Comandos útiles Docker & MariaDB](#comandos-útiles-docker--mariadb)

---

## 0. Requisitos del Proyecto Inception

| Categoría                     | Requisitos                                                                                                                                                                                |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Entorno**                   | - Máquina Virtual (VM).<br>- Uso de Docker Compose.<br>- Contenedores dedicados por servicio.<br>- Imágenes base: Alpine o Debian (última versión estable).                               |
| **Estructura de archivos**    | - Carpeta `srcs/` para todos los archivos.<br>- Makefile en raíz que construya todo (`docker-compose.yml`).<br>- Dockerfile por servicio, sin imágenes prehechas (excepto Alpine/Debian). |
| **Servicios obligatorios**    | - MariaDB (sin NGINX).<br>- WordPress con PHP-FPM (sin NGINX).<br>- NGINX (TLSv1.2 o TLSv1.3, puerto 443).                                                                                |
| **Volúmenes**                 | - Para base de datos de WordPress.<br>- Para archivos del sitio WordPress.                                                                                                                |
| **Redes**                     | - Docker network definida en `docker-compose.yml`.<br>- Prohibido `network: host`, `--link` o `links:`.                                                                                   |
| **Políticas de ejecución**    | - Contenedores se reinician automáticamente.<br>- Prohibido bucles infinitos (`tail -f`, `sleep infinity`).<br>- Buenas prácticas con PID 1 en Docker.                                    |
| **Base de datos**             | - 2 usuarios en WordPress, uno administrador (sin nombres tipo 'admin').                                                                                                                  |
| **Dominios y paths**          | - Volúmenes en `/home/login/data/` (reemplazar `login`).<br>- Configurar dominio `login.42.fr` → IP local.                                                                                |
| **Restricciones adicionales** | - Prohibido `latest` en imágenes.<br>- No guardar contraseñas en Dockerfiles.<br>- Uso de variables de entorno (`.env` y/o Docker secrets).                                               |
| **Entrada a la infra**        | - Único punto de entrada: NGINX puerto 443 con TLSv1.2/1.3.                                                                                                                               |
| **Bonus (opcional)**          | - Redis cache, FTP server, sitio estático, Adminer, otro servicio útil (solo si la parte obligatoria funciona).                                                                           |
| **Entrega y evaluación**      | - Subir al repositorio Git.<br>- Evaluación solo del contenido en el repo.<br>- Posibles cambios durante defensa.                                                                         |

---

## 🧱 Preparación del Entorno

* **Máquina Virtual (Debian)**: Entorno aislado para consistencia y evitar conflictos.
* Corregir error al iniciar VM (deVMX root mode):

  ```bash
  sudo rmmod kvm_intel
  ```

* **[Instalación de Docker y Docker Compose](doc/docker_install.md)**.
* Organización de carpetas base para separar configuraciones, servicios y secretos.

---

## 📁 Estructura del Proyecto

```
.
├── docs
│   ├── mariadb-help.txt
│   ├── nginx-help.txt
│   └── wordpress-help.txt
├── Makefile
├── secrets
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── wordpress_password.txt
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   ├── conf
        │   ├── Dockerfile
        │   └── tools
        │       ├── entrypoint.sh
        │       └── install.sh
        ├── wordpress
        │   ├── conf
        │   ├── Dockerfile
        │   └── tools
        └── nginx
            ├── conf
            ├── Dockerfile
            └── tools
```

---

## 📋 Descripción de Carpetas y Archivos

### 🔹 `requirements/mariadb/`

* **Propósito:** Contenedor MariaDB para WordPress.
* **Contenido:** Dockerfile, conf/, tools/, .dockerignore.
* Crear dos usuarios en la base de datos, uno administrador (sin nombres tipo 'admin').

### 🔹 `requirements/wordpress/`

* **Propósito:** Contenedor WordPress con PHP-FPM, depende de MariaDB.
* **Contenido:** Dockerfile, conf/, tools/, .dockerignore.
* Servido mediante NGINX, no expone puertos públicos.

### 🔹 `requirements/nginx/`

* **Propósito:** Puerta de entrada, sirve contenido HTTPS.
* **Contenido:**
  * `Dockerfile`: Construye imagen NGINX desde Alpine o Debian.
  * `conf/nginx.conf`: Configuración personalizada (certificados, proxy WordPress).
  * `tools/`: Scripts para generar certificados TLS autofirmados o configuraciones adicionales.
  * `.dockerignore`: Excluye archivos innecesarios.

### 🔹 `secrets/`

* Credenciales sensibles, no en Dockerfiles ni repositorio (`db_password.txt`, `db_root_password.txt`, `credentials.txt`).

### 🔹 `srcs/`

* `.env`, `docker-compose.yml`, `Makefile`, `requirements/`.

---

## 🐳 Configuración de Dockerfiles

* **MariaDB:** Usuarios personalizados y base de datos.
* **WordPress:** PHP-FPM, sin servidor web propio.
* **NGINX:** TLSv1.2/1.3, puerto 443, sin bucles infinitos.
* Base: Alpine o Debian, no usar imágenes preconstruidas como `wordpress:latest`.

---

## 🔐 Variables de Entorno

Ejemplo `.env`:

```env
DOMAIN_NAME=frromero.42.fr
MYSQL_ROOT_PASSWORD=...
MYSQL_USER=...
MYSQL_PASSWORD=...
MYSQL_DATABASE=wordpress
```

---

## 🧩 Configuración de Docker Compose

* Servicios: `mariadb` → `wordpress` → `nginx`.
* `build:` para cada servicio.
* Volúmenes persistentes para base de datos y WordPress.
* Red personalizada.
* `restart: always`.

---

## 🛠️ Makefile

```makefile
all:
	docker-compose --env-file srcs/.env -f srcs/docker-compose.yml up --build -d
```

---

## 🌐 Configuración del Dominio

```bash
echo "127.0.0.1 frromero.42.fr" | sudo tee -a /etc/hosts
```

---

## 🧪 Pruebas y Validación

* MariaDB funcionando correctamente.
* WordPress se conecta a MariaDB.
* NGINX sirve WordPress por HTTPS.
* Volúmenes persisten datos.
* Contenedores se reinician automáticamente.

---

## 🎁 Parte Bonus

* Redis cache, FTP server, sitio estático, Adminer, otro servicio.
* Permite abrir puertos adicionales según necesidad.

---

## 🐳 Comandos útiles Docker & MariaDB

### Fuera del contenedor

| Acción                       | Comando                              |
| ---------------------------- | ------------------------------------ |
| Ver contenedores activos     | `docker ps`                          |
| Ver todos los contenedores   | `docker ps -a`                       |
| Entrar al contenedor MariaDB | `docker exec -it mariadb bash`       |
| Ver logs del contenedor      | `docker logs mariadb`                |
| Parar contenedor             | `docker stop mariadb`                |
| Reiniciar contenedor         | `docker restart mariadb`             |
| Eliminar contenedor          | `docker rm mariadb`                  |
| Ver redes                    | `docker network ls`                  |
| Ver volúmenes                | `docker volume ls`                   |
| Inspeccionar volumen         | `docker volume inspect srcs_db_data` |

### Dentro del contenedor (cliente MariaDB)

```bash
mysql -u frromero -p
```

### Comandos SQL básicos

| Acción                 | Comando SQL                                          |
| ---------------------- | ---------------------------------------------------- |
| Ver bases de datos     | `SHOW DATABASES;`                                    |
| Usar base de datos     | `USE wordpress;`                                     |
| Ver tablas             | `SHOW TABLES;`                                       |
| Ver usuarios           | `SELECT user, host FROM mysql.user;`                 |
| Crear usuario          | `CREATE USER 'nombre'@'%' IDENTIFIED BY 'clave';`    |
| Crear base de datos    | `CREATE DATABASE nombre;`                            |
| Dar permisos           | `GRANT ALL PRIVILEGES ON nombre.* TO 'usuario'@'%';` |
| Ver permisos           | `SHOW GRANTS FOR 'usuario'@'%';`                     |
| Eliminar usuario       | `DROP USER 'usuario'@'%';`                           |
| Eliminar base de datos | `DROP DATABASE nombre;`                              |
| Salir                  | `exit`                                               |

### Acceder como root

```bash
mysql -u root -p
```
