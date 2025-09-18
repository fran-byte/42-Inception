FROM debian:bookworm-slim

ENV WORDPRESS_DB_HOST=mariadb
ENV WORDPRESS_DB_NAME=wordpress
ENV WORDPRESS_DB_USER=wpuser
ENV WORDPRESS_DB_PASSWORD=wppass

COPY tools/install.sh /install.sh
RUN chmod +x /install.sh

CMD ["/install.sh"]
