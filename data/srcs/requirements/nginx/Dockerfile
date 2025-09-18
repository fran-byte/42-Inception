FROM debian:bookworm-slim

COPY tools/install.sh /install.sh
RUN chmod +x /install.sh

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY certs/selfsigned.key /etc/ssl/private/selfsigned.key
COPY certs/selfsigned.crt /etc/ssl/certs/selfsigned.crt


EXPOSE 80
EXPOSE 443

CMD ["/install.sh"]
