#!/bin/bash

# This script is responsible for copying SSL keys from the secrets to the location where Nginx expects them.
# It should be run as part of the Nginx entrypoint to ensure that the keys
# are in place before Nginx starts.
set -e

# Define source and destination paths for SSL keys
SSL_SOURCE_DIR="/run/secrets/"
SSL_DEST_DIR="/etc/nginx/ssl/"

# Check if the source directory exists and is not empty
if [ -d "$SSL_SOURCE_DIR" ] && [ "$(ls -A "$SSL_SOURCE_DIR")" ]; then
	echo "Copying SSL keys from $SSL_SOURCE_DIR to $SSL_DEST_DIR..."
	mv "$SSL_SOURCE_DIR"/* "$SSL_DEST_DIR"/
	# Set appropriate permissions for the SSL keys (only readable by root)
	chmod 600 "$SSL_DEST_DIR"/*
	echo "SSL keys copied successfully."
else
	echo "Warning: No SSL keys found in $SSL_SOURCE_DIR. Nginx will start without SSL configuration." >&2
fi
