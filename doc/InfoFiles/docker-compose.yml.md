# 📌 docker-compose.yml para Inception (MariaDB + WordPress + Nginx)

Este archivo define la infraestructura de contenedores con **Docker Compose**, organizada en una red interna y con uso de **Docker secrets** para mayor seguridad.

---

## 🌐 Redes
- **`inception_net`** → Red tipo `bridge` que conecta los servicios entre sí.  

---

## 🛠️ Servicios

### 🗄️ MariaDB
- **Build**: `./requirements/mariadb`  
- **Container name**: `mariadb`  
- **Restart policy**: `always`  
- **Variables de entorno** (usan `secrets` en lugar de exponer contraseñas):  
  - `MYSQL_ROOT_PASSWORD_FILE` → Secreto con la contraseña de root.  
  - `MYSQL_DATABASE` → Nombre de la base de datos (`wordpress`).  
  - `MYSQL_USER` → Usuario de la base de datos (`wpuser`).  
  - `MYSQL_PASSWORD_FILE` → Secreto con la contraseña de `wpuser`.  
- **Volumen**:  
  - `${VOLUMES_ROOT}/db:/var/lib/mysql` → Persistencia de datos de la base de datos.  
- **Red**: `inception_net`.  
- **Secrets usados**:  
  - `db_root_password`  
  - `db_password`  

---

### 🌍 WordPress
- **Build**: `./requirements/wordpress`  
- **Container name**: `wordpress`  
- **Restart policy**: `always`  
- **Variables de entorno**:  
  - Configuración de conexión a MariaDB.  
  - Usuario administrador (`WORDPRESS_ADMIN_USER`).  
  - Contraseña admin vía secreto (`WORDPRESS_ADMIN_PASSWORD_FILE`).  
  - Correo del administrador.  
- **Volumen**:  
  - `${VOLUMES_ROOT}/wp:/var/www/html` → Archivos persistentes de WordPress.  
- **Red**: `inception_net`.  
- **Depends_on**: `mariadb`.  
- **Secrets usados**:  
  - `db_password`  
  - `wordpress_password`  

---

### ⚡ Nginx
- **Build**: `./requirements/nginx`  
- **Container name**: `nginx`  
- **Restart policy**: `always`  
- **Puertos**:  
  - `443:443` → Exposición del servidor con HTTPS.  
- **Volúmenes**:  
  - `${VOLUMES_ROOT}/wp:/var/www/html` → Archivos de WordPress.  
  - `./requirements/nginx/conf:/etc/nginx/conf.d` → Configuración de Nginx.  
  - `./requirements/nginx/certs:/etc/ssl/certs` → Certificados SSL.  
- **Red**: `inception_net`.  
- **Depends_on**: `wordpress`.  

---

## 🔑 Secrets
Los secretos se almacenan fuera del repositorio para evitar exponer contraseñas en el código:

- **`db_root_password`** → `../secrets/db_root_password.txt`  
- **`db_password`** → `../secrets/db_password.txt`  
- **`wordpress_password`** (comentado) → `../secrets/wordpress_password.txt`  

---

## 🚀 Flujo de ejecución esperado
1. **MariaDB** inicia primero y prepara la base de datos.  
2. **WordPress** se conecta a MariaDB usando secretos y variables de entorno.  
3. **Nginx** sirve la aplicación WordPress al exterior con HTTPS.  

---

✅ Con este `docker-compose.yml`, se obtiene una arquitectura segura y modular para desplegar WordPress con soporte HTTPS, persistencia de datos y contraseñas protegidas con Docker secrets.
