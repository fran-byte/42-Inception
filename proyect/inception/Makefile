# Variables
DC = docker compose                   # Alias for 'docker compose' command
DC_FILE = ./srcs/docker-compose.yml   # Path to docker-compose file

# Phony targets declaration
.PHONY: up stop rm status clean purge restart logs fix-perms logs-mariadb logs-wordpress logs-nginx help-mariadb help-wordpress help-nginx

# Start services
up:
	@mkdir -p ./data/db ./data/wp       # Create persistent folders for database and WordPress
	@sudo chown -R 999:999 ./data/db ./data/wp  # Set correct permissions
	@sudo chmod -R 755 ./data/db ./data/wp      # Set correct permissions
	@$(DC) -f $(DC_FILE) up --build -d  # Build and start containers in background

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
	@rm -rf ./data            # Remove local data folders
	@docker system prune -a -f # Remove unused images, containers and networks

# Restart everything from scratch
restart: clean up

# Fix permissions
fix-perms:
	@sudo chown -R 999:999 ./data/db ./data/wp
	@sudo chmod -R 755 ./data/db ./data/wp
	@echo "✅ Permissions fixed for data/db and data/wp"

# View MariaDB logs
logs-mariadb:
	@$(DC) -f $(DC_FILE) logs mariadb

# View WordPress logs (when active)
logs-wordpress:
	@$(DC) -f $(DC_FILE) logs wordpress

# View Nginx logs (when active)
logs-nginx:
	@$(DC) -f $(DC_FILE) logs nginx

# View logs for all services
logs:
	@$(DC) -f $(DC_FILE) logs

# MariaDB help
help-mariadb:
	@cat docs/mariadb-help.txt

# WordPress help (when active)
help-wordpress:
	@cat docs/wordpress-help.txt

# Nginx help (when active)
help-nginx:
	@cat docs/nginx-help.txt
