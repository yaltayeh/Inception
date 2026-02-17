#!/bin/sh
set -e

read_secret() {
    local secret_name="$1"
    local env_var_name="$2"
    local secret_default="$3"

    if [ -f "/run/secrets/${secret_name}" ]; then
        cat "/run/secrets/${secret_name}"
    else
        echo "${env_var_name:-$secret_default}"
    fi
}

MYSQL_DATABASE=$(read_secret mysql_database $MYSQL_DATABASE "my_database")
MYSQL_USER=$(read_secret mysql_user $MYSQL_USER "my_user")
MYSQL_USER_PASSWORD=$(read_secret mysql_user_password $MYSQL_USER_PASSWORD "user_password")
MYSQL_ROOT_PASSWORD=$(read_secret mysql_root_password $MYSQL_ROOT_PASSWORD "root_password")

echo "Using the following configuration:"
echo "  Database: ${MYSQL_DATABASE}"
echo "  User: ${MYSQL_USER}"
echo "  User Password: ${MYSQL_USER_PASSWORD}"
echo "  Root Password: ${MYSQL_ROOT_PASSWORD}"

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
    TMP_SOCKET="/tmp/mysql.sock"
    mariadbd --user=mysql \
        --skip-networking \
        --socket=$TMP_SOCKET \
        --datadir="$DATA_DIR" &
    pid="$!"

    while [ ! -S "$TMP_SOCKET" ]; do
        sleep 0.5
    done

    # Wait until server is ready
    until mysqladmin ping --socket=$TMP_SOCKET &>/dev/null; do
        sleep 0.5
    done

    # Set root password if provided
    if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
        mysql -uroot --socket=$TMP_SOCKET -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    fi
    echo "MariaDB initialized successfully."
    # Create user and database if provided
    if [ -n "$MYSQL_DATABASE" ]; then
        mysql -uroot --socket=$TMP_SOCKET -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    fi
    echo "Database '${MYSQL_DATABASE}' created (if it did not already exist)."
    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_USER_PASSWORD" ]; then
        mysql -uroot --socket=$TMP_SOCKET -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
        mysql -uroot --socket=$TMP_SOCKET -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-*}\`.* TO '${MYSQL_USER}'@'%';"
        mysql -uroot --socket=$TMP_SOCKET -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    fi

    # Stop temporary server
    mysqladmin --socket=$TMP_SOCKET -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    # Wait for server to stop
    wait "$pid"
fi

# Start MariaDB in foreground as PID 1
exec mariadbd --user=mysql --datadir="$DATA_DIR" --bind-address=0.0.0.0
