FROM debian:12-slim

# Install PHP, extensions, and dependencies
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-gd \
    php-xml \
    php-curl \
    php-mbstring \
    ca-certificates \
    mariadb-client \
    curl \
    unzip \
    less \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create necessary directories
RUN mkdir -p /run/php-fpm
RUN chown -R www-data:www-data /run/php-fpm

RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Metadata
LABEL version="1.0"
LABEL description="PHP-FPM Server for WordPress"

# Copy entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy custom PHP-FPM pool configuration
COPY pool.d/ /etc/php/8.2/fpm/pool.d/

# Start PHP-FPM
WORKDIR /var/www/html

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/wp-login.php || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "php-fpm8.2", "-F" ]
