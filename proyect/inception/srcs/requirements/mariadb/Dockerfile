FROM alpine:3.18

RUN apk update && apk add mariadb mariadb-client

# Crear directorios necesarios
RUN mkdir -p /var/lib/mysql /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld
RUN chmod -R 755 /var/lib/mysql /run/mysqld

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
