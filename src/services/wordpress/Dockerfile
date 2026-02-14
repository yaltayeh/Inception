FROM alpine:3.23

# Install PHP and necessary extensions for WordPress
RUN apk update && apk add --no-cache \
    gettext \
    php \
    php-fpm \
    php-opcache \
    php-mysqli \
    php-pdo \
    php-json \
    php-session \
    php-mbstring \
    php-ctype \
    php-iconv 

# Create www-data user
RUN adduser -S -G www-data www-data

# Create necessary directories
RUN mkdir -p /run/php-fpm
RUN chown -R www-data:www-data /run/php-fpm

RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Download and extract WordPress
RUN wget https://wordpress.org/latest.tar.gz -O /wordpress.tar.gz && \
    tar -zxf /wordpress.tar.gz --strip-components=1 -C /var/www/html && \
    rm /wordpress.tar.gz

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php*/php-fpm.d/*

# Expose PHP-FPM port
EXPOSE 9000

COPY website/* /var/www/html/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start PHP-FPM
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "php-fpm84", "-F" ]
