# Wordpress Dockerfile
# -----------------------------
# Base image
# From Docker Hub
# -----------------------------
FROM alpine:3.19

# -----------------------------
# Install required system packages and PHP extensions
# -----------------------------
RUN apk update && apk add \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-openssl \
    php83-xml \
    php83-zip \
    php83-phar \
    php83-session \
    php83-tokenizer \
    wget \
    curl \
    unzip \
    mariadb-client \
    bash \
    shadow \
    git

# -----------------------------
# Create symlink for php executable
# -----------------------------
RUN ln -s /usr/bin/php83 /usr/bin/php

# -----------------------------
# Create necessary directories and set permissions
# -----------------------------
RUN mkdir -p /var/www/html /run/php \
    && chown -R nobody:nobody /var/www/html /run/php \
    && chmod -R 755 /var/www/html

# -----------------------------
# Download and extract WordPress
# -----------------------------
RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /tmp/ \
    && cp -a /tmp/wordpress/. /var/www/html/ \
    && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

# -----------------------------
# Set final permissions for WordPress files
# -----------------------------
RUN chown -R nobody:nobody /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# -----------------------------
# Configure PHP-FPM
# -----------------------------
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

# -----------------------------
# Copy scripts
# -----------------------------
COPY tools/install.sh /usr/local/bin/install.sh
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY tools/init-users.php /usr/local/bin/init-users.php 
RUN chmod +x /usr/local/bin/install.sh /usr/local/bin/entrypoint.sh

# -----------------------------
# Run install.sh during build (e.g., install WP-CLI)
# -----------------------------
RUN /usr/local/bin/install.sh

# -----------------------------
# Set working directory
# -----------------------------
WORKDIR /var/www/html

# -----------------------------
# Expose PHP-FPM port
# -----------------------------
EXPOSE 9000

# -----------------------------
# Entrypoint
# -----------------------------
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
