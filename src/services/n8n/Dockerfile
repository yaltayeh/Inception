FROM debian:12-slim

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    tzdata \
    bash \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Create n8n user
RUN useradd -m -u 1000 -s /bin/bash node

# Create working directory
WORKDIR /home/node

# Install n8n globally
RUN npm install -g n8n

# Create data directory
RUN mkdir -p /home/node/.n8n \
    && chown -R node:node /home/node

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:5678/health || exit 1

# Important: exec form for proper PID 1 handling
ENTRYPOINT ["/entrypoint.sh"]
CMD [ ]
