
all:
	mkdir -p ~/data/mariadb
	mkdir -p ~/data/web
	mkdir -p ~/data/n8n
	docker compose --env-file .env -f src/docker-compose.yml up -d 

config:
	./scripts/configuration.sh

build:
	docker compose --env-file .env -f src/docker-compose.yml build 

logs:
	docker compose --env-file .env -f src/docker-compose.yml logs 

stop:
	docker compose --env-file .env -f src/docker-compose.yml stop

status:
	docker compose --env-file .env -f src/docker-compose.yml ps

clean:
	docker compose --env-file .env -f src/docker-compose.yml down 

fclean:
	./scripts/fclean.sh

re: fclean build all

.PHONY: all config build clean fclean
