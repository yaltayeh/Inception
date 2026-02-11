FROM debian:latest

RUN apt-get update
RUN apt-get install -y mariadb-server

EXPOSE 3306

LABEL version="1.0"
LABEL description="MariaDB Server"

HEALTHCHECK --start-period=5m \
    CMD mariadb -e 'SELECT @@datadir;' || exit 1

ENTRYPOINT ["entrypoint.sh"]
CMD ["mariadbd"] // fallback to default command if no command is provided
