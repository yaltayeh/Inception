#!/bin/sh
set -e

# Set default values for environment variables if not provided
export WORDPRESS_DB_NAME=${WORDPRESS_DB_NAME:-wordpress}
export WORDPRESS_DB_USER=${WORDPRESS_DB_USER:-wordpress}
export WORDPRESS_DB_PASSWORD=${WORDPRESS_DB_PASSWORD:-wordpress}
export WORDPRESS_DB_HOST=${WORDPRESS_DB_HOST:-db:3306}

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root
    wp config create --dbname="$WORDPRESS_DB_NAME" \
                     --dbuser="$WORDPRESS_DB_USER" \
                     --dbpass="$WORDPRESS_DB_PASSWORD" \
                     --dbhost="$WORDPRESS_DB_HOST" \
                     --allow-root
    wp core install --url="$DOMAIN_NAME \
                    --title="My Site" \
                    --admin_user="admin" \
                    --admin_password="adminpassword" \
                    --admin_email="you@example.com" \
                    --allow-root
fi

exec "$@"
