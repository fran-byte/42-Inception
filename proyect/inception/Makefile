# ==============================================================================
# CONFIGURACIÓN DEL PROYECTO DOCKER - INCEPTION
# Makefile optimizado para desarrollo y producción
# ==============================================================================

# Docker Compose
DC = docker compose --env-file srcs/.env
DC_FILE = ./srcs/docker-compose.yml

# Nombres de servicios
APP_NAME = wordpress
DB_NAME = mariadb
WEB_NAME = nginx

# Configuración de puertos
PORT_WEB = 443
PORT_APP = 9000
PORT_DB = 3306

# Colores para mensajes
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
BLUE = \033[0;34m
NC = \033[0m

# ==============================================================================
# HELP - TARGET POR DEFECTO
# ==============================================================================
.PHONY: help
help:
	@echo "$(GREEN)=== COMANDOS DISPONIBLES ===$(NC)"
	@echo ""
	@echo "$(YELLOW)DESARROLLO:$(NC)"
	@echo "  make up           # Levantar entorno completo"
	@echo "  make stop         # Detener todos los servicios"
	@echo "  make restart      # Reiniciar todos los servicios"
	@echo "  make logs         # Ver logs de todos los servicios"
	@echo "  make ps           # Estado de contenedores"
	@echo ""
	@echo "$(YELLOW)CONSTRUCCIÓN:$(NC)"
	@echo "  make build        # Construir imágenes"
	@echo "  make rebuild      # Reconstruir sin cache"
	@echo ""
	@echo "$(YELLOW)SERVICIOS INDIVIDUALES - STOP:$(NC)"
	@echo "  make stop_mariadb     # Detener solo MariaDB"
	@echo "  make stop_wp          # Detener solo WordPress"
	@echo "  make stop_nginx       # Detener solo Nginx"
	@echo ""
	@echo "$(YELLOW)SERVICIOS INDIVIDUALES - LOGS:$(NC)"
	@echo "  make logs_mariadb     # Logs de MariaDB"
	@echo "  make logs_wp          # Logs de WordPress"
	@echo "  make logs_nginx       # Logs de Nginx"
	@echo ""
	@echo "$(YELLOW)SERVICIOS INDIVIDUALES - RESTART:$(NC)"
	@echo "  make restart_mariadb  # Reiniciar solo MariaDB"
	@echo "  make restart_wp       # Reiniciar solo WordPress"
	@echo "  make restart_nginx    # Reiniciar solo Nginx"
	@echo ""
	@echo "$(YELLOW)SERVICIOS INDIVIDUALES - REBUILD:$(NC)"
	@echo "  make rebuild_mariadb  # Reconstruir MariaDB"
	@echo "  make rebuild_wp       # Reconstruir WordPress"
	@echo "  make rebuild_nginx    # Reconstruir Nginx"
	@echo ""
	@echo "$(YELLOW)DIAGNÓSTICO:$(NC)"
	@echo "  make diagnose         # Diagnóstico completo"
	@echo "  make test_db_connection # Probar conexión BD"
	@echo "  make check_db_users   # Verificar usuarios BD"
	@echo "  make verify_db_setup  # Verificar setup BD"
	@echo ""
	@echo "$(YELLOW)UTILIDADES:$(NC)"
	@echo "  make fix_perms        # Corregir permisos"
	@echo "  make clean            # Limpiar contenedores y volúmenes"
	@echo "  make purge            # Limpieza completa (incluye datos)"
	@echo "  make validate         # Validar configuración"
	@echo ""
	@echo "$(YELLOW)EJEMPLOS:$(NC)"
	@echo "  make build up         # Construir y levantar"
	@echo "  make stop clean       # Detener y limpiar"
	@echo "  make logs_mariadb     # Ver logs de base de datos"

# ==============================================================================
# TARGETS DE DESARROLLO
# ==============================================================================
.PHONY: up stop restart ps logs

# Levantar entorno de desarrollo
up:
	@echo "$(GREEN)🚀 Iniciando entorno de desarrollo...$(NC)"
	@mkdir -p ./data/db ./data/wp
	@$(MAKE) fix_perms
	@$(DC) -f $(DC_FILE) up --build -d
	@echo "$(GREEN)✅ Entorno listo!$(NC)"

# Detener todos los servicios sin eliminar
stop:
	@echo "$(YELLOW)⏸️ Deteniendo todos los servicios...$(NC)"
	@$(DC) -f $(DC_FILE) stop

# Reiniciar todos los servicios
restart: stop up
	@echo "$(GREEN)🔄 Todos los servicios reiniciados$(NC)"

# Estado de los contenedores
ps:
	@$(DC) -f $(DC_FILE) ps

# Ver logs de todos los servicios
logs:
	@$(DC) -f $(DC_FILE) logs --follow

# ==============================================================================
# TARGETS DE CONSTRUCCIÓN
# ==============================================================================
.PHONY: build rebuild

# Construir imágenes
build:
	@echo "$(GREEN)🔨 Construyendo imágenes...$(NC)"
	@$(DC) -f $(DC_FILE) build

# Reconstruir todas las imágenes sin cache
rebuild:
	@echo "$(YELLOW)🔄 Reconstruyendo todas las imágenes sin cache...$(NC)"
	@$(DC) -f $(DC_FILE) build --no-cache
	@$(MAKE) up

# ==============================================================================
# TARGETS INDIVIDUALES - STOP SERVICES
# ==============================================================================
.PHONY: stop_mariadb stop_wp stop_nginx

# Detener solo MariaDB
stop_mariadb:
	@echo "$(YELLOW)⏸️ Deteniendo MariaDB...$(NC)"
	@$(DC) -f $(DC_FILE) stop $(DB_NAME)

# Detener solo WordPress
stop_wp:
	@echo "$(YELLOW)⏸️ Deteniendo WordPress...$(NC)"
	@$(DC) -f $(DC_FILE) stop $(APP_NAME)

# Detener solo Nginx
stop_nginx:
	@echo "$(YELLOW)⏸️ Deteniendo Nginx...$(NC)"
	@$(DC) -f $(DC_FILE) stop $(WEB_NAME)

# ==============================================================================
# TARGETS INDIVIDUALES - VIEW LOGS
# ==============================================================================
.PHONY: logs_mariadb logs_wp logs_nginx

# Logs de MariaDB
logs_mariadb:
	@echo "$(BLUE)📋 Logs de MariaDB (últimas 50 líneas):$(NC)"
	@$(DC) -f $(DC_FILE) logs --tail=50 $(DB_NAME)

# Logs de WordPress
logs_wp:
	@echo "$(BLUE)📋 Logs de WordPress (últimas 50 líneas):$(NC)"
	@$(DC) -f $(DC_FILE) logs --tail=50 $(APP_NAME)

# Logs de Nginx
logs_nginx:
	@echo "$(BLUE)📋 Logs de Nginx (últimas 50 líneas):$(NC)"
	@$(DC) -f $(DC_FILE) logs --tail=50 $(WEB_NAME)

# ==============================================================================
# TARGETS INDIVIDUALES - RESTART SERVICES
# ==============================================================================
.PHONY: restart_mariadb restart_wp restart_nginx

# Reiniciar solo MariaDB
restart_mariadb:
	@echo "$(YELLOW)🔄 Reiniciando MariaDB...$(NC)"
	@$(DC) -f $(DC_FILE) stop $(DB_NAME)
	@$(DC) -f $(DC_FILE) up -d $(DB_NAME)
	@echo "$(GREEN)✅ MariaDB reiniciado$(NC)"

# Reiniciar solo WordPress
restart_wp:
	@echo "$(YELLOW)🔄 Reiniciando WordPress...$(NC)"
	@$(DC) -f $(DC_FILE) stop $(APP_NAME)
	@$(DC) -f $(DC_FILE) up -d $(APP_NAME)
	@echo "$(GREEN)✅ WordPress reiniciado$(NC)"

# Reiniciar solo Nginx
restart_nginx:
	@echo "$(YELLOW)🔄 Reiniciando Nginx...$(NC)"
	@$(DC) -f $(DC_FILE) stop $(WEB_NAME)
	@$(DC) -f $(DC_FILE) up -d $(WEB_NAME)
	@echo "$(GREEN)✅ Nginx reiniciado$(NC)"

# ==============================================================================
# TARGETS INDIVIDUALES - REBUILD SERVICES
# ==============================================================================
.PHONY: rebuild_mariadb rebuild_wp rebuild_nginx

# Reconstruir MariaDB sin cache
rebuild_mariadb:
	@echo "$(YELLOW)🔨 Reconstruyendo MariaDB sin cache...$(NC)"
	@$(DC) -f $(DC_FILE) build --no-cache $(DB_NAME)
	@$(DC) -f $(DC_FILE) up -d $(DB_NAME)
	@echo "$(GREEN)✅ MariaDB reconstruido$(NC)"

# Reconstruir WordPress sin cache
rebuild_wp:
	@echo "$(YELLOW)🔨 Reconstruyendo WordPress sin cache...$(NC)"
	@$(DC) -f $(DC_FILE) build --no-cache $(APP_NAME)
	@$(DC) -f $(DC_FILE) up -d $(APP_NAME)
	@echo "$(GREEN)✅ WordPress reconstruido$(NC)"

# Reconstruir Nginx sin cache
rebuild_nginx:
	@echo "$(YELLOW)🔨 Reconstruyendo Nginx sin cache...$(NC)"
	@$(DC) -f $(DC_FILE) build --no-cache $(WEB_NAME)
	@$(DC) -f $(DC_FILE) up -d $(WEB_NAME)
	@echo "$(GREEN)✅ Nginx reconstruido$(NC)"

# ==============================================================================
# DIAGNÓSTICO DE BASE DE DATOS (SOLO LECTURA)
# ==============================================================================
.PHONY: diagnose test_db_connection check_db_users verify_db_setup

# Diagnóstico completo
diagnose:
	@echo "$(YELLOW)=== DIAGNÓSTICO COMPLETO ===$(NC)"
	@echo "1. Verificando archivos críticos..."
	@if [ -f "srcs/.env" ]; then \
		echo "$(GREEN)✅ .env existe$(NC)"; \
	else \
		echo "$(RED)❌ .env NO existe$(NC)"; \
	fi
	@echo ""
	@echo "2. Verificando contenedores..."
	@$(DC) -f $(DC_FILE) ps
	@echo ""
	@echo "3. Verificando wp-config.php en WordPress..."
	@docker exec $$(docker ps -q -f name=wordpress) ls -la /var/www/html/wp-config.php 2>/dev/null && echo "$(GREEN)✅ wp-config.php existe$(NC)" || echo "$(RED)❌ wp-config.php NO existe$(NC)"
	@echo ""
	@echo "4. Verificando conexión a base de datos..."
	@docker exec $$(docker ps -q -f name=mariadb) mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" 2>/dev/null && echo "$(GREEN)✅ MariaDB funcionando$(NC)" || echo "$(RED)❌ Error conectando a MariaDB$(NC)"

# Probar conexión desde WordPress a MariaDB
test_db_connection:
	@echo "$(YELLOW)🔍 Probando conexión WordPress → MariaDB...$(NC)"
	@echo "1. Probando conectividad de red..."
	@docker exec wordpress ping -c 2 mariadb >/dev/null 2>&1 && echo "$(GREEN)✅ WordPress puede alcanzar MariaDB$(NC)" || echo "$(RED)❌ No hay conectividad de red$(NC)"
	@echo ""
	@echo "2. Probando puerto 3306..."
	@docker exec wordpress nc -z mariadb 3306 >/dev/null 2>&1 && echo "$(GREEN)✅ Puerto 3306 accesible$(NC)" || echo "$(RED)❌ Puerto 3306 no accesible$(NC)"
	@echo ""
	@echo "3. Probando conexión MySQL con usuario wp_to_db_user..."
	@docker exec wordpress mysql -h mariadb -u wp_to_db_user -p"$$DB_PASSWORD" -e "SELECT 1;" 2>/dev/null && echo "$(GREEN)✅ Conexión MySQL exitosa$(NC)" || echo "$(RED)❌ Conexión MySQL falló - VERIFICAR USUARIO/CONTRASEÑA$(NC)"

# Verificar usuarios y permisos en MariaDB (SOLO LECTURA)
check_db_users:
	@echo "$(YELLOW)👥 Verificando usuarios y permisos en MariaDB...$(NC)"
	@docker exec mariadb mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -e "\
	SELECT '=== USUARIOS EXISTENTES ===' as '';\
	SELECT user, host FROM mysql.user;\
	SELECT '=== PERMISOS wp_to_db_user ===' as '';\
	SHOW GRANTS FOR 'wp_to_db_user'@'%';" 2>/dev/null || echo "$(RED)❌ No se pudo conectar a MariaDB como root$(NC)"

# Verificar configuración completa de la base de datos (SOLO LECTURA)
verify_db_setup:
	@echo "$(YELLOW)📊 Verificando setup de la base de datos...$(NC)"
	@docker exec mariadb mysql -u root -p"$$MYSQL_ROOT_PASSWORD" -e "\
	SELECT '=== BASES DE DATOS ===' as '';\
	SHOW DATABASES;\
	SELECT '=== USUARIOS MYSQL ===' as '';\
	SELECT user, host FROM mysql.user WHERE user LIKE '%wp%' OR user LIKE '%db%';\
	SELECT '=== PRIVILEGIOS wp_to_db_user ===' as '';\
	SHOW GRANTS FOR 'wp_to_db_user'@'%';" 2>/dev/null || echo "$(RED)❌ Error al verificar setup de BD$(NC)"

# ==============================================================================
# TARGETS DE UTILIDADES
# ==============================================================================
.PHONY: fix_perms check_ports validate check_env

# Corregir permisos de los volúmenes
fix_perms:
	@echo "$(GREEN)🔧 Ajustando permisos...$(NC)"
	@sudo chown -R 999:999 ./data/db ./data/wp 2>/dev/null || true
	@sudo chmod -R 755 ./data/db ./data/wp 2>/dev/null || true
	@echo "$(GREEN)✅ Permisos correctos$(NC)"

# Verificar puertos en uso
check_ports:
	@echo "$(YELLOW)🔍 Verificando puertos...$(NC)"
	@netstat -tulpn 2>/dev/null | grep :$(PORT_WEB) && echo "$(RED)❌ Puerto $(PORT_WEB) en uso$(NC)" || echo "$(GREEN)✅ Puerto $(PORT_WEB) libre$(NC)"
	@netstat -tulpn 2>/dev/null | grep :$(PORT_APP) && echo "$(RED)❌ Puerto $(PORT_APP) en uso$(NC)" || echo "$(GREEN)✅ Puerto $(PORT_APP) libre$(NC)"

# Validar configuración
validate:
	@if [ ! -f "srcs/.env" ]; then \
		echo "$(RED)❌ Error: Archivo srcs/.env no encontrado$(NC)"; \
		exit 1; \
	fi
	@if [ ! -f "$(DC_FILE)" ]; then \
		echo "$(RED)❌ Error: Archivo $(DC_FILE) no encontrado$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Configuración válida$(NC)"

# Verificar variables de entorno
check_env:
	@echo "$(YELLOW)📋 Variables de entorno:$(NC)"
	@cat srcs/.env | grep -v "^#" | grep -v "^$$"

# ==============================================================================
# TARGETS DE LIMPIEZA
# ==============================================================================
.PHONY: clean purge

# Limpiar contenedores y volúmenes
clean:
	@echo "$(YELLOW)🧹 Limpiando contenedores y volúmenes...$(NC)"
	@$(DC) -f $(DC_FILE) down -v
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

# Limpieza completa (incluye datos locales)
purge: clean
	@echo "$(RED)🔥 Eliminando todos los datos excepto docs/, secrets/, srcs/ y Makefile...$(NC)"
	@find . -maxdepth 1 -mindepth 1 \
		! -name 'docs' \
		! -name 'secrets' \
		! -name 'srcs' \
		! -name 'Makefile' \
		-exec rm -rf {} +
	@docker volume rm srcs_db_data srcs_wp_data 2>/dev/null || true
	@docker system prune -a -f
	@echo "$(YELLOW)⚠ Todos los datos generados han sido eliminados. Ejecuta 'make up' para reiniciar.$(NC)"

# ==============================================================================
# DEPENDENCIAS ENTRE TARGETS
# ==============================================================================
# Asegurar validación antes de up y build
up: validate
build: validate

# Declaración de todos los targets phony
.PHONY: help up stop restart ps logs build rebuild \
        stop_mariadb stop_wp stop_nginx \
        logs_mariadb logs_wp logs_nginx \
        restart_mariadb restart_wp restart_nginx \
        rebuild_mariadb rebuild_wp rebuild_nginx \
        diagnose test_db_connection check_db_users verify_db_setup \
        fix_perms check_ports validate check_env \
        clean purge
