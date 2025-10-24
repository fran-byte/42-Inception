# ==============================================================================
# ULTRA-MINIMAL MAKEFILE WITH PURGE-ALL - INCEPTION
# ==============================================================================

DC = docker compose
DC_DIR = ./srcs

.PHONY: help mandatory-up mandatory-bonus-up bonus-up redis-test redis-config stop restart logs build rebuild clean purge purge-all

# =======================================================================
# HELP
# =======================================================================
help:
	@echo "Available commands:"
	@echo "  make mandatory-up        # Start MANDATORY services only"
	@echo "  make mandatory-bonus-up  # Start MANDATORY + BONUS services"
	@echo "  make bonus-up            # Start BONUS only (if mandatory is running)"
	@echo "  make redis-test          # Performance test with/without Redis"
	@echo "  make redis-config        # Add Redis configuration to WordPress"
	@echo "  make stop                # Stop all services"
	@echo "  make restart             # Restart all services"
	@echo "  make logs                # View all service logs"
	@echo "  make build               # Build images"
	@echo "  make rebuild             # Rebuild images without cache"
	@echo "  make clean               # Clean containers only (keep volumes)"
	@echo "  make purge               # Clean containers + images (keep volumes)"
	@echo "  make purge-all           # Nuclear cleanup (containers + images + volumes + files)"

# =======================================================================
# SERVICES
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
	@echo "⚙️  CONFIGURING REDIS WITH WP-CLI..."
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_HOST redis --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_PORT 6379 --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_TIMEOUT 1 --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_READ_TIMEOUT 1 --add=true --type=constant
	@echo "✅ Redis configuration added with WP-CLI"
	@echo "🎯 Install the plugin from WordPress Admin"

# =======================================================================
# TESTING
# =======================================================================
redis-test:
	@echo "🔍 STARTING REDIS PERFORMANCE TEST"
	@echo "========================================"
	@cd $(DC_DIR) && bash -c '\
		echo -e "\n✅ CURRENT STATUS - Redis CONNECTED"; \
		docker compose ps | grep redis; \
		echo -e "\n  MEASUREMENT WITH Redis:"; \
		for i in 1 2 3; do \
			tiempo=$$(curl -k -w "%{time_total}" -o /dev/null -s https://frromero.42.fr/); \
			echo "  Request $$i: $${tiempo}s"; \
		done; \
		echo -e "\n  STOPPING Redis..."; \
		docker compose stop redis; \
		sleep 2; \
		echo -e "\n  MEASUREMENT WITHOUT Redis:"; \
		for i in 1 2 3; do \
			tiempo=$$(curl -k -w "%{time_total}" -o /dev/null -s https://frromero.42.fr/); \
			echo "  Request $$i: $${tiempo}s"; \
		done; \
		echo -e "\n  STARTING Redis..."; \
		docker compose --profile bonus up -d redis; \
		sleep 5; \
		until docker compose exec redis redis-cli ping 2>/dev/null | grep -q "PONG"; do \
			echo "Waiting for Redis to be ready..."; \
			sleep 2; \
		done; \
		echo "✅ Redis reconnected: PONG"; \
		echo -e "\n  MEASUREMENT WITH Redis (reactivated):"; \
		for i in 1 2 3; do \
			tiempo=$$(curl -k -w "%{time_total}" -o /dev/null -s https://frromero.42.fr/); \
			echo "  Request $$i: $${tiempo}s"; \
		done; \
	'

# =======================================================================
# BUILD
# =======================================================================
build:
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) mandatory-up

# =======================================================================
# CLEANUP
# =======================================================================
clean:
	@cd $(DC_DIR) && $(DC) --profile bonus down

purge: clean
	@docker system prune -a -f

purge-all: clean
	@echo "🔥 NUCLEAR CLEANUP - Removing everything except secrets/, srcs/ and Makefile..."
	@find . -maxdepth 1 -mindepth 1 \
		! -name 'secrets' \
		! -name 'srcs' \
		! -name 'Makefile' \
		-exec rm -rf {} +
	@docker volume rm srcs_db_data srcs_wp_data 2>/dev/null || true
	@docker system prune -a -f