DOCKER_COMPOSE=docker compose
DOCKER_COMPOSE_FILE=./srcs/docker-compose.yml

.PHONY: kill build down clean fclean restart re logs

build:
	@mkdir -p ./data/mariadb
	@mkdir -p ./data/wordpress
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up --build -d

kill:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) kill

down:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down

clean:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	@rm -rf ./data/mariadb
	@rm -rf ./data/wordpress
	@docker system prune -a -f

restart: clean build

re: fclean build

logs:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f
