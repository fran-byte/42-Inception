FROM alpine:3.19

# Instalar paquetes necesarios del sistema
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

# Crear symlink para que 'php' apunte a 'php83'
RUN ln -s /usr/bin/php83 /usr/bin/php

# Crear directorios necesarios
RUN mkdir -p /var/www/html /run/php \
    && chown -R nobody:nobody /var/www/html /run/php \
    && chmod -R 755 /var/www/html

# Descargar y descomprimir WordPress directamente en /var/www/html
RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /tmp/ \
    && cp -a /tmp/wordpress/. /var/www/html/ \
    && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

# Ajustar permisos finales
RUN chown -R nobody:nobody /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Configurar PHP-FPM
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

# Copiar scripts
COPY tools/install.sh /usr/local/bin/install.sh
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY tools/init-users.php /usr/local/bin/init-users.php 
RUN chmod +x /usr/local/bin/install.sh /usr/local/bin/entrypoint.sh

# EJECUTAR install.sh durante el build para instalar WP-CLI
RUN /usr/local/bin/install.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
