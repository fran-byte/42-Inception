# ==============================================================================
# CONFIGURACIÓN DEL PROYECTO DOCKER - INCEPTION
# ==============================================================================

# Docker Compose (ejecutado desde srcs/ donde está el .env)
DC = docker compose
DC_DIR = ./srcs

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
	@echo "$(YELLOW)SERVICIOS PRINCIPALES:$(NC)"
	@echo "  make up           # Levantar todos los servicios"
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
	@echo "$(YELLOW)LIMPIEZA:$(NC)"
	@echo "  make clean            # Limpiar contenedores y volúmenes"
	@echo "  make purge            # Limpieza completa (incluye datos)"

# ==============================================================================
# TARGETS PRINCIPALES
# ==============================================================================
.PHONY: up stop restart ps logs

up:
	@echo "$(GREEN)🚀 Levantando todos los servicios...$(NC)"
	@cd $(DC_DIR) && $(DC) up --build -d
	@echo "$(GREEN)✅ Servicios listos!$(NC)"

stop:
	@echo "$(YELLOW)⏸ Deteniendo todos los servicios...$(NC)"
	@cd $(DC_DIR) && $(DC) stop

restart: stop up
	@echo "$(GREEN)🔄 Todos los servicios reiniciados$(NC)"

ps:
	@cd $(DC_DIR) && $(DC) ps

logs:
	@cd $(DC_DIR) && $(DC) logs --follow

# ==============================================================================
# TARGETS DE CONSTRUCCIÓN
# ==============================================================================
.PHONY: build rebuild

build:
	@echo "$(GREEN)🔨 Construyendo imágenes...$(NC)"
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@echo "$(YELLOW)🔄 Reconstruyendo todas las imágenes sin cache...$(NC)"
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) up

# ==============================================================================
# TARGETS INDIVIDUALES - STOP SERVICES
# ==============================================================================
.PHONY: stop_mariadb stop_wp stop_nginx

stop_mariadb:
	@echo "$(YELLOW)⏸ Deteniendo MariaDB...$(NC)"
	@cd $(DC_DIR) && $(DC) stop $(DB_NAME)

stop_wp:
	@echo "$(YELLOW)⏸ Deteniendo WordPress...$(NC)"
	@cd $(DC_DIR) && $(DC) stop $(APP_NAME)

stop_nginx:
	@echo "$(YELLOW)⏸ Deteniendo Nginx...$(NC)"
	@cd $(DC_DIR) && $(DC) stop $(WEB_NAME)

# ==============================================================================
# TARGETS INDIVIDUALES - VIEW LOGS
# ==============================================================================
.PHONY: logs_mariadb logs_wp logs_nginx

logs_mariadb:
	@echo "$(BLUE)📋 Logs de MariaDB (últimas 50 líneas):$(NC)"
	@cd $(DC_DIR) && $(DC) logs --tail=50 $(DB_NAME)

logs_wp:
	@echo "$(BLUE)📋 Logs de WordPress (últimas 50 líneas):$(NC)"
	@cd $(DC_DIR) && $(DC) logs --tail=50 $(APP_NAME)

logs_nginx:
	@echo "$(BLUE)📋 Logs de Nginx (últimas 50 líneas):$(NC)"
	@cd $(DC_DIR) && $(DC) logs --tail=50 $(WEB_NAME)

# ==============================================================================
# TARGETS INDIVIDUALES - RESTART SERVICES
# ==============================================================================
.PHONY: restart_mariadb restart_wp restart_nginx

restart_mariadb:
	@echo "$(YELLOW)🔄 Reiniciando MariaDB...$(NC)"
	@cd $(DC_DIR) && $(DC) stop $(DB_NAME)
	@cd $(DC_DIR) && $(DC) up -d $(DB_NAME)
	@echo "$(GREEN)✅ MariaDB reiniciado$(NC)"

restart_wp:
	@echo "$(YELLOW)🔄 Reiniciando WordPress...$(NC)"
	@cd $(DC_DIR) && $(DC) stop $(APP_NAME)
	@cd $(DC_DIR) && $(DC) up -d $(APP_NAME)
	@echo "$(GREEN)✅ WordPress reiniciado$(NC)"

restart_nginx:
	@echo "$(YELLOW)🔄 Reiniciando Nginx...$(NC)"
	@cd $(DC_DIR) && $(DC) stop $(WEB_NAME)
	@cd $(DC_DIR) && $(DC) up -d $(WEB_NAME)
	@echo "$(GREEN)✅ Nginx reiniciado$(NC)"

# ==============================================================================
# TARGETS INDIVIDUALES - REBUILD SERVICES
# ==============================================================================
.PHONY: rebuild_mariadb rebuild_wp rebuild_nginx

rebuild_mariadb:
	@echo "$(YELLOW)🔨 Reconstruyendo MariaDB sin cache...$(NC)"
	@cd $(DC_DIR) && $(DC) build --no-cache $(DB_NAME)
	@cd $(DC_DIR) && $(DC) up -d $(DB_NAME)
	@echo "$(GREEN)✅ MariaDB reconstruido$(NC)"

rebuild_wp:
	@echo "$(YELLOW)🔨 Reconstruyendo WordPress sin cache...$(NC)"
	@cd $(DC_DIR) && $(DC) build --no-cache $(APP_NAME)
	@cd $(DC_DIR) && $(DC) up -d $(APP_NAME)
	@echo "$(GREEN)✅ WordPress reconstruido$(NC)"

rebuild_nginx:
	@echo "$(YELLOW)🔨 Reconstruyendo Nginx sin cache...$(NC)"
	@cd $(DC_DIR) && $(DC) build --no-cache $(WEB_NAME)
	@cd $(DC_DIR) && $(DC) up -d $(WEB_NAME)
	@echo "$(GREEN)✅ Nginx reconstruido$(NC)"

# ==============================================================================
# TARGETS DE LIMPIEZA
# ==============================================================================

.PHONY: clean purge reset

# Limpiar contenedores pero MANTENER volúmenes
reset:
	@echo "$(YELLOW)🔄 Reiniciando contenedores (manteniendo volúmenes)...$(NC)"
	@cd $(DC_DIR) && $(DC) down
	@echo "$(GREEN)✅ Contenedores reiniciados, volúmenes preservados$(NC)"
clean:
	@echo "$(YELLOW)🧹 Limpiando contenedores y volúmenes...$(NC)"
	@cd $(DC_DIR) && $(DC) down -v
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

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

.PHONY: help up stop restart ps logs build rebuild \
		stop_mariadb stop_wp stop_nginx \
		logs_mariadb logs_wp logs_nginx \
		restart_mariadb restart_wp restart_nginx \
		rebuild_mariadb rebuild_wp rebuild_nginx \
		clean purge validate

# Validación mínima
validate:
	@echo "$(GREEN)✅ Validación completada$(NC)"
