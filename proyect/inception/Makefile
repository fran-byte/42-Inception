# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: frromero <frromero@student.42madrid.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/10 20:12:48 by frromero          #+#    #+#              #
#    Updated: 2025/10/26 19:20:00 by frromero         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DC = docker compose
DC_DIR = ./srcs
VOLUMES_ROOT := $(PROJECT_ROOT)/data


.PHONY: help setup-data mandatory-up bonus-up redis-test redis-config stop restart logs build rebuild purge purge-all

# -----------------------------
# CREATE DATA FOLDERS WITH CORRECT PERMISSIONS
# -----------------------------
setup-data:
	@echo "📁 Creating data directories with correct permissions..."
	@mkdir -p data/db data/wp
	@chown -R $$(id -u):$$(id -g) data/db data/wp
	@chmod -R 755 data/db data/wp
	@echo "✅ Data directories ready!"

# =======================================================================
# HELP
# =======================================================================
help:
	@echo "Available commands:"
	@echo "  make mandatory-up        # Start MANDATORY services only"
# 	@echo "  make mandatory-bonus-up  # Start MANDATORY + BONUS services"
	@echo "  make bonus-up            # Start BONUS only (if mandatory is running)"
	@echo "  make redis-test          # Performance test with/without Redis"
	@echo "  make redis-config        # Add Redis configuration to WordPress"
	@echo "  make stop                # Stop all services"
	@echo "  make restart             # Restart all services"
	@echo "  make logs                # View all service logs"
	@echo "  make build               # Build images"
	@echo "  make rebuild             # Rebuild images without cache"
	@echo "  make purge               # Clean all containers, images and volumes (mandatory + bonus)"
	@echo "  make purge-all           # Full cleanup: containers, images, volumes, and extra files"

# =======================================================================
# SERVICES
# =======================================================================
mandatory-up:
	@cd $(DC_DIR) && $(DC) up --build -d

# mandatory-bonus-up:
# 	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

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
purge:
	@cd $(DC_DIR) && $(DC) --profile bonus down --remove-orphans
	@docker system prune -a -f
	@docker builder prune -af
	@docker volume prune -f

purge-all: purge
	@echo "☢️ NUCLEAR CLEANUP - Removing extra files..."
	@docker volume prune -f
	@docker builder prune -af
	@rm -rf data/db/* data/wp/*
# 	@find . -maxdepth 1 -mindepth 1 \
# 		! -name 'secrets' \
# 		! -name 'srcs' \
# 		! -name 'Makefile' \
# 		-exec rm -rf {} +

