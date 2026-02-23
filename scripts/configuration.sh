#!/bin/bash
set -e

cp env.example .env

# Add HOST_UID and HOST_GID to .env for Docker containers
echo "" >> .env
echo "# Host user UID/GID for bind mount ownership" >> .env
echo "HOST_UID=$(id -u)" >> .env
echo "HOST_GID=$(id -g)" >> .env

. .env

mkdir -p secrets

# Create data directories for bind mounts (owned by current user)
echo "Creating data directories..."
mkdir -p ~/data/mariadb ~/data/web ~/data/n8n
echo "Data directories created."

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
echo "Pass1234" > secrets/ftp_password.txt
