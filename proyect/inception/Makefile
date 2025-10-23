# ==============================================================================
# MAKEFILE ULTRA-MÍNIMO CON REL-PURGE - INCEPTION
# ==============================================================================

DC = docker compose
DC_DIR = ./srcs

.PHONY: help up mandatory-bonus-up bonus-up stop restart logs build rebuild clean purge rel-purge

# =======================================================================
# HELP
# =======================================================================
help:
	@echo "Comandos disponibles:"
	@echo "  make up        # Levantar solo servicios MANDATORY"
	@echo "  make up-bonus  # Levantar MANDATORY + BONUS"
	@echo "  make bonus-only # Levantar solo BONUS (si mandatory está corriendo)"
	@echo "  make stop      # Detener todos los servicios"
	@echo "  make restart   # Reiniciar todos los servicios"
	@echo "  make logs      # Ver logs de todos los servicios"
	@echo "  make build     # Construir imágenes"
	@echo "  make rebuild   # Reconstruir imágenes sin cache"
	@echo "  make clean     # Limpiar contenedores y volúmenes"
	@echo "  make purge     # Limpieza completa, incluye datos"
	@echo "  make rel-purge # Limpieza avanzada pero conserva docs/, secrets/, srcs/ y Makefile"

# =======================================================================
# SERVICIOS
# =======================================================================
# Solo mandatory (sin bonus)
up:
	@cd $(DC_DIR) && $(DC) up --build -d

# Mandatory + Bonus
mandatory-bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

# Solo bonus (asumiendo que mandatory está corriendo)
bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d static-web

stop:
	@cd $(DC_DIR) && $(DC) stop

restart: stop up

logs:
	@cd $(DC_DIR) && $(DC) logs --follow

# =======================================================================
# CONSTRUCCIÓN
# =======================================================================
build:
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) up

# =======================================================================
# LIMPIEZA
# =======================================================================
clean:
	@cd $(DC_DIR) && $(DC) --profile bonus down -v


purge: clean
	@docker system prune -a -f

rel-purge: clean
	@echo "🔥 Eliminando todo excepto docs/, secrets/, srcs/ y Makefile..."
	@find . -maxdepth 1 -mindepth 1 \
		! -name 'docs' \
		! -name 'secrets' \
		! -name 'srcs' \
		! -name 'Makefile' \
		-exec rm -rf {} +
	@docker volume rm srcs_db_data srcs_wp_data 2>/dev/null || true
	@docker system prune -a -f
