FROM debian:12-slim

# Install Nginx and cleanup apt cache
RUN apt-get update && \
	apt-get install -y nginx gettext-base && \
	rm -rf /var/lib/apt/lists/*

# Copy SSL certificates
COPY ./ssl /etc/nginx/ssl

# Copy templates
COPY ./templates /etc/nginx/templates

# Copy entrypoint script and make it executable
COPY entrypoint.d /entrypoint.d
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
	chmod -R +x /entrypoint.d

# Metadata
LABEL version="1.0"
LABEL description="Nginx Web Server"

# Healthcheck
# HEALTHCHECK --interval=10s --timeout=5s --start-period=30s \
# 	CMD curl -f https://${DOMAIN_NAME}/ || exit 1

RUN chmod -R 755 /var/www/html

# Expose default Nginx port
EXPOSE 80 443

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]
