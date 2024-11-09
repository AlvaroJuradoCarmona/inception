
NGINX_DIR			= /home/$(USER)/data
WORDPRESS_DIR		= $(NGINX_DIR)/wordpress
MARIADB_DIR			= $(NGINX_DIR)/mariadb
DOCKER_COMPOSE		= ./srcs/docker-compose.yml

all: up

up:
		mkdir -p $(NGINX_DIR)
		mkdir -p $(MARIADB_DIR)
		mkdir -p $(WORDPRESS_DIR)
	 	docker compose -f $(DOCKER_COMPOSE) up --build

down:
		docker compose -f $(DOCKER_COMPOSE) down

clean: down
	if [ $$(docker container ls -qa | wc -l) -gt 0 ]; then \
		docker container rm -f $$(docker container ls -qa); \
	fi
	if [ $$(docker image ls -qa | wc -l) -gt 0 ]; then \
		docker image rm -f $$(docker image ls -qa); \
	fi
	if [ $$(docker network ls --filter type=custom -q | wc -l) -gt 0 ]; then \
    docker network rm $$(docker network ls --filter type=custom -q); \
	fi
	rm -rf $(MARIADB_DIR)
	rm -rf $(WORDPRESS_DIR)

fclean: clean
		if [ $$(docker volume ls -q | wc -l) -gt 0 ]; then \
			docker volume rm $$(docker volume ls -q); \
		fi
		rm -rf $(NGINX_DIR)

re: fclean all

.PHONY: all up down clean fclean re
