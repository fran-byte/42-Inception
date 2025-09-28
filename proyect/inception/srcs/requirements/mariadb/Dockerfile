# MariaDB Dockerfile
# -----------------------------
# Base image
# From Docker Hub
# -----------------------------
FROM alpine:3.19

# -----------------------------
# Install MariaDB and Client
# -----------------------------
RUN apk update && apk add --no-cache mariadb mariadb-client

# -----------------------------
# Create necessary directories
# -----------------------------
RUN mkdir -p /run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# -----------------------------
# Copy configuration files and scripts
# -----------------------------
COPY conf/my.cnf /etc/my.cnf
COPY tools/entrypoint.sh /usr/local/bin/
COPY tools/install.sh /usr/local/bin/

# -----------------------------
# Set executable permissions
# -----------------------------
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/install.sh

# -----------------------------
# Expose MariaDB port and define data volume
# -----------------------------
EXPOSE 3306
VOLUME /var/lib/mysql

# -----------------------------
# Entrypoint and default command
# -----------------------------
ENTRYPOINT ["entrypoint.sh"]
CMD ["mysqld", "--user=mysql"]
