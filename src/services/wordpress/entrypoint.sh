#!/bin/sh
set -e

# Function to read secrets from Docker secrets if available, otherwise exit with an error
read_secret() {
    local secret_name="$1"

    if [ -f "/run/secrets/${secret_name}" ]; then
        cat "/run/secrets/${secret_name}"
    else
        echo "Error: Secret '${secret_name}' not found in /run/secrets/${secret_name}." >&2
        exit 1
    fi
}

check_env() {
    local var_name="$1"
    local var_value="${var_name}"

    if [ -z "$var_value" ]; then
        echo "Error: Environment variable '${var_name}' is not set." >&2
        exit 1
    fi
}

install_wordpress() {
    check_env WORDPRESS_DB_HOST
    check_env WORDPRESS_DB_USER
    check_env WORDPRESS_DB_NAME
    check_env DOMAIN_NAME
    check_env WORDPRESS_ADMIN_USER
    check_env WORDPRESS_ADMIN_EMAIL

    WORDPRESS_DB_PASSWORD=$(read_secret wordpress_user_password )
    WORDPRESS_ADMIN_PASSWORD=$(read_secret wordpress_admin_password)
    WORDPRESS_SITE_TITLE=${WORDPRESS_SITE_TITLE:-My WordPress Site}
    WORDPRESS_LOCALE=${WORDPRESS_LOCALE:-en_US}

    wp core download --locale="$WORDPRESS_LOCALE" --allow-root

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
    
    # Set Template and activate it
    if [ -n "$WORDPRESS_THEME" ]; then
        wp theme install "$WORDPRESS_THEME" --activate --allow-root
    fi
    
    
}

echo "Starting WordPress entrypoint script..."
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found, installing..."
    install_wordpress

fi

exec "$@"
