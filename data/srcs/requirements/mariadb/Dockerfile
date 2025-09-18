FROM debian:bookworm-slim

ENV MYSQL_ROOT_PASSWORD=Eskorbuto13/12
ENV MYSQL_USER=wpuser
ENV MYSQL_PASSWORD=Eskorbuto13/12
ENV WORDPRESS_DB_NAME=wordpress

COPY tools/install.sh /install.sh
RUN chmod +x /install.sh

CMD ["/install.sh"]
