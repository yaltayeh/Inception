#!/bin/bash

echo "This will remove all containers, volumes, and networks created by docker-compose. Are you sure? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    docker compose -f src/docker-compose.yml down -v
    echo "All containers, volumes, and networks have been removed."
    rm -rf ~/data/*
else
    echo "Operation cancelled."
fi
