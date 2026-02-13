#!/bin/bash
set -e


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
    mariadbd --initialize-insecure --user=mysql --datadir="$DATA_DIR"

    # Start temporary server to configure users
    mariadbd --skip-networking --socket=/tmp/mysql.sock --datadir="$DATA_DIR" &
    pid="$!"

    # Wait until server is ready
    until mysqladmin ping --socket=/tmp/mysql.sock &>/dev/null; do
        sleep 1
    done

    # Set root password if provided
    if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
        mysql -uroot --socket=/tmp/mysql.sock -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    fi

    # Create user and database if provided
    if [ -n "$MYSQL_DATABASE" ]; then
        mysql -uroot --socket=/tmp/mysql.sock -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    fi

    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
        mysql -uroot --socket=/tmp/mysql.sock -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
        mysql -uroot --socket=/tmp/mysql.sock -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-*}\`.* TO '${MYSQL_USER}'@'%';"
        mysql -uroot --socket=/tmp/mysql.sock -e "FLUSH PRIVILEGES;"
    fi

    # Stop temporary server
    kill "$pid"
    # Wait for the server to shut down gracefully
    wait "$pid"
fi

# Start MariaDB in foreground as PID 1
exec mariadbd --datadir="$DATA_DIR" --user=mysql
