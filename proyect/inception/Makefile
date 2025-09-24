# Variables

# Definiendo punto de montaje (será donde esté ubicado este Makefile)
PROJECT_ROOT := $(shell pwd)
export PROJECT_ROOT

# Docker Compose con env-file
DC = docker compose --env-file srcs/.env
DC_FILE = ./srcs/docker-compose.yml   # Path to docker-compose file

# Phony targets declaration
.PHONY: up stop rm status clean purge restart logs fix-perms \
        logs-mariadb logs-wordpress logs-nginx \
        restart-mariadb restart-wordpress restart-nginx \
        rebuild-mariadb rebuild-wordpress rebuild-nginx \
        help-mariadb help-wordpress help-nginx

# Start services
up:
	@mkdir -p ./data/db ./data/wp                        # Create persistent folders for database and WordPress
	@sudo chown -R 999:999 ./data/db ./data/wp           # Set correct permissions
	@sudo chmod -R 755 ./data/db ./data/wp              # Set correct permissions
	@$(DC) -f $(DC_FILE) up --build -d                   # Build and start containers in background

# Estado de los contenedores
status:
	@$(DC) -f $(DC_FILE) ps

# Stop containers without removing them
stop:
	@$(DC) -f $(DC_FILE) stop

# Remove containers (but keep volumes and data)
rm:
	@$(DC) -f $(DC_FILE) down

# Remove containers and volumes
clean:
	@$(DC) -f $(DC_FILE) down -v

# Full cleanup: containers, volumes, local folders and Docker cache
purge: clean
	@rm -rf ./data                  # Remove local data folders
	@docker volume rm srcs_db_data srcs_wp_data || true # Remove Volume
	@docker system prune -a -f      # Remove unused images, containers and networks

# Restart everything from scratch
restart: clean up

# Fix permissions
fix-perms:
	@sudo chown -R 999:999 ./data/db ./data/wp
	@sudo chmod -R 755 ./data/db ./data/wp
	@echo "✅ Permissions fixed for data/db and data/wp"

# View logs for individual services
logs-mariadb:
	@$(DC) -f $(DC_FILE) logs --tail=50 mariadb

logs-wordpress:
	@$(DC) -f $(DC_FILE) logs --tail=50 wordpress

logs-nginx:
	@$(DC) -f $(DC_FILE) logs --tail=50 nginx

# View logs for all services
logs:
	@$(DC) -f $(DC_FILE) logs

# Restart individual services
restart-mariadb:
	@$(DC) -f $(DC_FILE) stop mariadb
	@$(DC) -f $(DC_FILE) rm -f mariadb
	@$(DC) -f $(DC_FILE) up -d mariadb

restart-wordpress:
	@$(DC) -f $(DC_FILE) stop wordpress
	@$(DC) -f $(DC_FILE) rm -f wordpress
	@$(DC) -f $(DC_FILE) up -d wordpress

restart-nginx:
	@$(DC) -f $(DC_FILE) stop nginx
	@$(DC) -f $(DC_FILE) rm -f nginx
	@$(DC) -f $(DC_FILE) up -d nginx

# Rebuild individual services
rebuild-mariadb:
	@$(DC) -f $(DC_FILE) build --no-cache mariadb
	@$(DC) -f $(DC_FILE) up -d mariadb

rebuild-wordpress:
	@$(DC) -f $(DC_FILE) build --no-cache wordpress
	@$(DC) -f $(DC_FILE) up -d wordpress

rebuild-nginx:
	@$(DC) -f $(DC_FILE) build --no-cache nginx
	@$(DC) -f $(DC_FILE) up -d nginx

# MariaDB help
help-mariadb:
	@cat docs/mariadb-help.txt

# WordPress help (when active)
help-wordpress:
	@cat docs/wordpress-help.txt

# Nginx help (when active)
help-nginx:
	@cat docs/nginx-help.txt
