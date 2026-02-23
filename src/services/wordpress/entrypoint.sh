#!/bin/sh
set -e

# Adjust www-data user UID/GID to match host user if specified
if [ -n "$HOST_UID" ] && [ "$HOST_UID" != "$(id -u www-data)" ]; then
    echo "Adjusting www-data user UID to $HOST_UID..."
    usermod -u "$HOST_UID" www-data
fi
if [ -n "$HOST_GID" ] && [ "$HOST_GID" != "$(getent group www-data | cut -d: -f3)" ]; then
    echo "Adjusting www-data group GID to $HOST_GID..."
    groupmod -g "$HOST_GID" www-data
fi

# Fix ownership of working directories
chown -R www-data:www-data /var/www/html /run/php-fpm 2>/dev/null || true

# Function to read secrets from files or environment variables
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

DOMAIN_NAME=$(read_secret domain_name $DOMAIN_NAME "localhost")

WORDPRESS_DB_HOST=$(read_secret WORDPRESS_DB_HOST $WORDPRESS_DB_HOST "db")
WORDPRESS_DB_NAME=$(read_secret wordpress_database $WORDPRESS_DB_NAME "wordpress")
WORDPRESS_DB_PASSWORD=$(read_secret wordpress_user_password $WORDPRESS_DB_PASSWORD "password")
WORDPRESS_DB_USER=$(read_secret wordpress_user $WORDPRESS_DB_USER "wordpress")

WORDPRESS_ADMIN_USER=$(read_secret wordpress_admin_user $WORDPRESS_ADMIN_USER "admin")
WORDPRESS_ADMIN_PASSWORD=$(read_secret wordpress_admin_password $WORDPRESS_ADMIN_PASSWORD "password")
WORDPRESS_ADMIN_EMAIL=$(read_secret wordpress_admin_email $WORDPRESS_ADMIN_EMAIL "admin@example.com")

WORDPRESS_SITE_TITLE=${WORDPRESS_SITE_TITLE:-My WordPress Site}
WORDPRESS_LOCALE=${WORDPRESS_LOCALE:-en_US}

REDIS_HOST=$(read_secret redis_host $REDIS_HOST "")
REDIS_PORT=$(read_secret redis_port $REDIS_PORT "6379")

install_redis_cache() {
    echo "Installing Redis plugin..."
    wp plugin install redis-cache --activate --allow-root

    wp config set WP_REDIS_HOST $REDIS_HOST --allow-root
    wp config set WP_REDIS_PORT $REDIS_PORT --raw --allow-root

    wp redis enable --allow-root
    echo "Redis cache enabled."
}

install_wordpress() {
    
    until mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" &>/dev/null; do
        echo "Waiting for database connection..."
        sleep 0.5
    done

    wp core download --allow-root

    wp config create --dbname="$WORDPRESS_DB_NAME" \
                    --dbuser="$WORDPRESS_DB_USER" \
                    --dbpass="$WORDPRESS_DB_PASSWORD" \
                    --dbhost="$WORDPRESS_DB_HOST" \
                    --allow-root

    wp core install --url="$DOMAIN_NAME" \
                    --title="$WORDPRESS_SITE_TITLE" \
                    --admin_user="$WORDPRESS_ADMIN_USER" \
                    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
                    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
                    --allow-root

    if [ -n "$REDIS_HOST" ] && [ -n "$REDIS_PORT" ]; then
        install_redis_cache
    fi
}

echo "Starting WordPress entrypoint script..."
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found, installing..."
    install_wordpress
fi

exec "$@"
