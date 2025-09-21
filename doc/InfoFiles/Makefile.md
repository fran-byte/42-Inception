# 📌 Makefile para entorno Docker (WordPress + MariaDB + Nginx)

Este `Makefile` simplifica la gestión de un entorno Docker con **docker-compose**, automatizando tareas comunes como levantar, detener, limpiar y revisar logs de los servicios.

---

## ⚙️ Variables principales
- **`DC`** → Alias para `docker compose`.
- **`DC_FILE`** → Ruta del archivo `docker-compose.yml` (`./srcs/docker-compose.yml`).

---

## 🔑 Targets disponibles

### ▶️ Gestión de contenedores
- **`up`** →  
  - Crea carpetas persistentes (`./data/db`, `./data/wp`).  
  - Ajusta permisos adecuados.  
  - Construye e inicia los contenedores en segundo plano.  

- **`stop`** → Detiene los contenedores sin eliminarlos.  
- **`rm`** → Elimina contenedores, pero conserva volúmenes y datos.  
- **`clean`** → Elimina contenedores **y** volúmenes.  
- **`purge`** → Limpieza total:  
  - Ejecuta `clean`.  
  - Borra la carpeta `./data`.  
  - Ejecuta `docker system prune -a -f` para limpiar imágenes, contenedores y redes sin usar.  

- **`restart`** → Reinicia todo desde cero (`clean` + `up`).  

---

### 🔒 Permisos
- **`fix-perms`** → Ajusta permisos correctos en `./data/db` y `./data/wp`.  

---

### 📜 Logs
- **`logs`** → Muestra logs de todos los servicios.  
- **`logs-mariadb`** → Logs específicos de MariaDB.  
- **`logs-wordpress`** → Logs específicos de WordPress.  
- **`logs-nginx`** → Logs específicos de Nginx.  

---

### 📖 Ayuda
- **`help-mariadb`** → Muestra `docs/mariadb-help.txt`.  
- **`help-wordpress`** → Muestra `docs/wordpress-help.txt`.  
- **`help-nginx`** → Muestra `docs/nginx-help.txt`.  

---

## 🚀 Uso rápido
```bash
make up          # Inicia los servicios
make stop        # Detiene los contenedores
make clean       # Elimina contenedores y volúmenes
make purge       # Limpieza total del entorno
make logs        # Ver todos los logs
make fix-perms   # Reparar permisos de carpetas
