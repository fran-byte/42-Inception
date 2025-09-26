FROM alpine:3.19

RUN apk update && apk add --no-cache nginx openssl

# Copiar configuración global
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copiar server block
COPY conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
