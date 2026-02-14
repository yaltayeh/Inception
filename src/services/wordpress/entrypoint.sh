#!/bin/sh
set -e

# Set default values for environment variables if not provided
export WORDPRESS_DB_NAME=${WORDPRESS_DB_NAME:-wordpress}
export WORDPRESS_DB_USER=${WORDPRESS_DB_USER:-wordpress}
export WORDPRESS_DB_PASSWORD=${WORDPRESS_DB_PASSWORD:-wordpress}
export WORDPRESS_DB_HOST=${WORDPRESS_DB_HOST:-db:3306}

# Generate random keys and salts if not provided via environment variables
export WORDPRESS_AUTH_KEY=${WORDPRESS_AUTH_KEY:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_SECURE_AUTH_KEY=${WORDPRESS_SECURE_AUTH_KEY:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_LOGGED_IN_KEY=${WORDPRESS_LOGGED_IN_KEY:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_NONCE_KEY=${WORDPRESS_NONCE_KEY:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_AUTH_SALT=${WORDPRESS_AUTH_SALT:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_SECURE_AUTH_SALT=${WORDPRESS_SECURE_AUTH_SALT:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_LOGGED_IN_SALT=${WORDPRESS_LOGGED_IN_SALT:-$(head -c 32 /dev/urandom | base64)}
export WORDPRESS_NONCE_SALT=${WORDPRESS_NONCE_SALT:-$(head -c 32 /dev/urandom | base64)}

# filter='^(WORDPRESS_|WP_)$'

defined_envs=$(printf '${%s} ' $(awk "END { for (name in ENVIRON) { print ( name ~ /${filter}/ ) ? name : \"\" } }" < /dev/null ))

echo "defined_envs:" $defined_envs

envsubst "$defined_envs" < /var/www/html/wp-config-sample.php > /var/www/html/wp-config.php

exec "$@"
