# ==============================================================================
# MAKEFILE ULTRA-MÍNIMO CON REL-PURGE - INCEPTION
# ==============================================================================

DC = docker compose
DC_DIR = ./srcs

.PHONY: help mandatory-up mandatory-bonus-up bonus-up redis-test redis-config stop restart logs build rebuild clean purge rel-purge

# =======================================================================
# HELP
# =======================================================================
help:
	@echo "Comandos disponibles:"
	@echo "  make mandatory-up        # Levantar solo servicios MANDATORY"
	@echo "  make mandatory-bonus-up  # Levantar MANDATORY + BONUS"
	@echo "  make bonus-up            # Levantar solo BONUS (si mandatory está corriendo)"
	@echo "  make redis-test          # Test de performance con/sin Redis"
	@echo "  make redis-config        # Añadir configuración Redis a WordPress"
	@echo "  make stop                # Detener todos los servicios"
	@echo "  make restart             # Reiniciar todos los servicios"
	@echo "  make logs                # Ver logs de todos los servicios"
	@echo "  make build               # Construir imágenes"
	@echo "  make rebuild             # Reconstruir imágenes sin cache"
	@echo "  make clean               # Limpiar contenedores y volúmenes"
	@echo "  make purge               # Limpieza completa, incluye datos"
	@echo "  make rel-purge           # Limpieza avanzada pero conserva docs/, secrets/, srcs/ y Makefile"

# =======================================================================
# SERVICIOS
# =======================================================================
mandatory-up:
	@cd $(DC_DIR) && $(DC) up --build -d

mandatory-bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

stop:
	@cd $(DC_DIR) && $(DC) stop

restart: stop mandatory-up

logs:
	@cd $(DC_DIR) && $(DC) logs --follow

# =======================================================================
# REDIS CONFIGURATION
# =======================================================================
redis-config:
	@echo "⚙️  CONFIGURANDO REDIS CON WP-CLI..."
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_HOST redis --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_PORT 6379 --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_TIMEOUT 1 --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_READ_TIMEOUT 1 --add=true --type=constant
	@echo "✅ Configuración Redis añadida con WP-CLI"
	@echo "🎯 Instala el plugin desde WordPress Admin"
# =======================================================================
# TESTING
# =======================================================================
redis-test:
	@echo "🔍 INICIANDO TEST DE PERFORMANCE REDIS"
	@echo "========================================"
	@cd $(DC_DIR) && bash -c '\
		echo -e "\n✅ ESTADO ACTUAL - Redis CONECTADO"; \
		docker compose ps | grep redis; \
		echo -e "\n  MEDICIÓN CON Redis:"; \
		for i in 1 2 3; do \
			tiempo=$$(curl -k -w "%{time_total}" -o /dev/null -s https://frromero.42.fr/); \
			echo "  Petición $$i: $${tiempo}s"; \
		done; \
		echo -e "\n  DETENIENDO Redis..."; \
		docker compose stop redis; \
		sleep 2; \
		echo -e "\n  MEDICIÓN SIN Redis:"; \
		for i in 1 2 3; do \
			tiempo=$$(curl -k -w "%{time_total}" -o /dev/null -s https://frromero.42.fr/); \
			echo "  Petición $$i: $${tiempo}s"; \
		done; \
		echo -e "\n  LEVANTANDO Redis..."; \
		docker compose --profile bonus up -d redis; \
		sleep 5; \
		until docker compose exec redis redis-cli ping 2>/dev/null | grep -q "PONG"; do \
			echo "Esperando que Redis esté listo..."; \
			sleep 2; \
		done; \
		echo "✅ Redis reconectado: PONG"; \
		echo -e "\n  MEDICIÓN CON Redis (reactivado):"; \
		for i in 1 2 3; do \
			tiempo=$$(curl -k -w "%{time_total}" -o /dev/null -s https://frromero.42.fr/); \
			echo "  Petición $$i: $${tiempo}s"; \
		done; \
	'

# =======================================================================
# CONSTRUCCIÓN
# =======================================================================
build:
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) mandatory-up

# =======================================================================
# LIMPIEZA
# =======================================================================
clean:
	@cd $(DC_DIR) && $(DC) --profile bonus down -v

purge: clean
	@docker system prune -a -f

rel-purge: clean
	@echo "🔥 Eliminando todo excepto secrets/, srcs/ y Makefile..."
	@find . -maxdepth 1 -mindepth 1 \
		! -name 'secrets' \
		! -name 'srcs' \
		! -name 'Makefile' \
		-exec rm -rf {} +
	@docker volume rm srcs_db_data srcs_wp_data 2>/dev/null || true
	@docker system prune -a -f