#!/bin/sh
set -e

cp .env.example .env

source .env

mkdir -p secrets

# Generate self-signed certificate if DOMAIN_NAME is set
if [ -n "$DOMAIN_NAME" ]; then
    DOMAIN="$DOMAIN_NAME"
    openssl req -x509 -newkey rsa:4096 -nodes -days 365 \
      -keyout secrets/$DOMAIN.key \
      -out secrets/$DOMAIN.crt \
      -subj "/CN=$DOMAIN"
    echo "Generated self-signed certificate for $DOMAIN at secrets/$DOMAIN.crt and secrets/$DOMAIN.key"
fi

echo "Admin1234" > secrets/wordpress_admin_password.txt
echo "Root1234" > secrets/mysql_root_password.txt
echo "User1234" > secrets/mysql_user_password.txt
