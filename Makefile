
all:
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/web
	docker compose --env-file .env -f src/docker-compose.yml up -d 

config:
	./scripts/configuration.sh

build:
	docker compose --env-file .env -f src/docker-compose.yml build 

logs:
	docker compose --env-file .env -f src/docker-compose.yml logs 


clean:
	docker compose --env-file .env -f src/docker-compose.yml down 

fclean:
	./scripts/fclean.sh

.PHONY: all config build clean fclean
