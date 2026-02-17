# ---------- Build Stage ----------
FROM debian:12-slim AS builder

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: curl, git, build tools
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Node 20 LTS manually
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy source and build
COPY . .
RUN npm run build

# ---------- Production Stage ----------
FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: curl, git, build tools
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*


# Install Node 20 LTS manually
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "start"]
