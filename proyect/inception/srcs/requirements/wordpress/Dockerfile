FROM alpine:3.18

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
    mariadb-client

# Crear directorios necesarios
RUN mkdir -p /var/www/html /run/php
RUN chown -R nobody:nobody /var/www/html /run/php
RUN chmod -R 755 /var/www/html

# Configurar PHP-FPM
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

# Copiar scripts
COPY tools/install.sh /usr/local/bin/install.sh
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/install.sh /usr/local/bin/entrypoint.sh

# Ejecutar script de instalación
RUN /usr/local/bin/install.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
