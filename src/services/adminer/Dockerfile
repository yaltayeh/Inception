FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Apache + PHP + DB drivers
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-pgsql \
    php-sqlite3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download Adminer
RUN curl -L https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php \
    -o /var/www/html/index.php
RUN chmod 644 /var/www/html/index.php

RUN rm -rf /var/www/html/*.html

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose Apache port
EXPOSE 80

# Run Apache in foreground (important for PID 1)
CMD ["apachectl", "-D", "FOREGROUND"]
