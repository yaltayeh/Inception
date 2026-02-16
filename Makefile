
all:
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/web
	docker-compose up -d -f src/docker-compose.yml

config:
	./configuration.sh

build:
	docker-compose build -f src/docker-compose.yml

clean:
	docker-compose down -f src/docker-compose.yml

fclean:
	@echo "This will remove all containers, volumes, and networks created by docker-compose. Are you sure? (y/n)"
	@read answer; \
	if [ "$$answer" = "y" ]; then \
		docker-compose down -v -f src/docker-compose.yml; \
		echo "All containers, volumes, and networks have been removed."; \
	else \
		echo "Operation cancelled."; \
	fi

.PHONY: all config build clean fclean