FROM alpine:3.19

RUN apk update && apk add nginx
RUN mkdir -p /run/nginx /var/log/nginx /usr/share/nginx/html

# Copiar configuración principal
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Copiar contenido estático
COPY ./html /usr/share/nginx/html
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]