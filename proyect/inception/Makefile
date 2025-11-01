
DC = docker compose
DC_DIR = ./srcs
VOLUMES_ROOT := $(PROJECT_ROOT)/data

.PHONY: setup-data mandatory-up bonus-up  stop restart logs build rebuild purge purge-all 

# CREATE DATA FOLDERS WITH CORRECT PERMISSIONS
setup-data:
	@echo "Creating data directories with correct permissions"
	@mkdir -p data/db data/wp
	@chown -R $$(id -u):$$(id -g) data/db data/wp
	@chmod -R 755 data/db data/wp
	@echo "Data directories ready"

# SERVICES
mandatory-up:
	@cd $(DC_DIR) && $(DC) up --build -d

bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

stop:
	@cd $(DC_DIR) && $(DC) stop

restart: stop mandatory-up

logs:
	@cd $(DC_DIR) && $(DC) logs --follow

# BUILD
build:
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) mandatory-up

# CLEANUP
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

