FROM debian:12-slim

# Install MariaDB and cleanup apt cache
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Expose default MariaDB port
EXPOSE 3306

# Metadata
LABEL version="1.0"
LABEL description="MariaDB Server"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Ensure /var/lib/mysql is owned by mysql
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Healthcheck using runtime environment variables
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s \
    CMD bash -c 'mysqladmin ping -uroot -p"$MYSQL_ROOT_PASSWORD" || exit 1'

# Entrypoint + default CMD
ENTRYPOINT ["/entrypoint.sh"]
CMD []
