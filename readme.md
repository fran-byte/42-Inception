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
