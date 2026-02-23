FROM debian:12-slim

# Install MariaDB and cleanup apt cache
RUN apt-get update && \
    apt-get install -y mariadb-server passwd && \
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
RUN rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Healthcheck using runtime environment variables
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD mysqladmin ping -uroot -p"$MYSQL_ROOT_PASSWORD" || exit 1

# Entrypoint + default CMD
# ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/entrypoint.sh"]
CMD []
