# requirements/mariadb/Dockerfile
FROM alpine:3.18

# Instalar MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

# Crear directorios necesarios
RUN mkdir -p /run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copiar archivos de configuración
COPY conf/my.cnf /etc/my.cnf
COPY tools/entrypoint.sh /usr/local/bin/
COPY tools/install.sh /usr/local/bin/

# Dar permisos de ejecución
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/install.sh

# Puerto expuesto
EXPOSE 3306

# Volumen para datos
VOLUME /var/lib/mysql

# Entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["mysqld", "--user=mysql"]
