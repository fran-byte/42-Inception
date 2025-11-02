FROM alpine:3.21

RUN apk add --no-cache nginx \
    && mkdir -p /run/nginx /var/log/nginx /usr/share/nginx/html

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
COPY ./html /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
