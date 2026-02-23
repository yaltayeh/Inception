#!/bin/sh
set -e

# Adjust node user UID/GID to match host user if specified
if [ -n "$HOST_UID" ] && [ "$HOST_UID" != "$(id -u node)" ]; then
    echo "Adjusting node user UID to $HOST_UID..."
    usermod -u "$HOST_UID" node
fi
if [ -n "$HOST_GID" ] && [ "$HOST_GID" != "$(getent group node | cut -d: -f3)" ]; then
    echo "Adjusting node group GID to $HOST_GID..."
    groupmod -g "$HOST_GID" node
fi

# Fix ownership of data directory
chown -R node:node /home/node/.n8n 2>/dev/null || true

# Run n8n as node user
exec gosu node n8n "$@"
