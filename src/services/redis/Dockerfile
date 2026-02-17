FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Redis
RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Create redis data directory
RUN mkdir -p /data \
    && chown -R redis:redis /data

# Expose Redis port
EXPOSE 6379

# Run as redis user
USER redis

# Use exec form (important for PID 1)
ENTRYPOINT [ "redis-server", "--appendonly", "yes", "--dir", "/data" ]
CMD [ ]
