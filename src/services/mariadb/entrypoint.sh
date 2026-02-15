#!/bin/bash
set -e

read_secret() {
    local secret_name="$1"
    local secret_default="$2"

    if [ -f "/run/secrets/${secret_name}" ]; then
        cat "/run/secrets/${secret_name}"
    else
        echo "Warning: Secret '${secret_name}' not found. Using default value." >&2
        echo "${secret_default}"
    fi
}

MYSQL_ROOT_PASSWORD=$(read_secret mysql_root_password "")
MYSQL_PASSWORD=$(read_secret mysql_user_password "")

# Ensure socket directory exists
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Ensure data directory exists
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

DATA_DIR="/var/lib/mysql"
# Initialize DB if not already initialized
if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "Initializing MariaDB database..."

    mariadb-install-db --user=mysql --datadir="$DATA_DIR" > /dev/null
    # Start temporary server to configure users
    mariadbd --user=mysql \
        --skip-networking \
        --socket=/tmp/mysql.sock \
        --datadir="$DATA_DIR" &
    pid="$!"

    # Wait until server is ready
    until mysqladmin ping --socket=/tmp/mysql.sock &>/dev/null; do
        sleep 1
    done

    # Set root password if provided
    if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
        mysql -uroot --socket=/tmp/mysql.sock -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    fi
    echo "MariaDB initialized successfully."
    # Create user and database if provided
    if [ -n "$MYSQL_DATABASE" ]; then
        mysql -uroot --socket=/tmp/mysql.sock -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    fi
    echo "Database '${MYSQL_DATABASE}' created (if it did not already exist)."
    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
        mysql -uroot --socket=/tmp/mysql.sock -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
        mysql -uroot --socket=/tmp/mysql.sock -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-*}\`.* TO '${MYSQL_USER}'@'%';"
        mysql -uroot --socket=/tmp/mysql.sock -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    fi

    # Stop temporary server
    mysqladmin --socket=/tmp/mysql.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    # Wait for server to stop
    wait "$pid"
fi

# Start MariaDB in foreground as PID 1
exec mariadbd --user=mysql --datadir="$DATA_DIR" --bind-address=0.0.0.0
