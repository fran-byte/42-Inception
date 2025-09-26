FROM alpine:3.19

RUN apk update && apk add --no-cache nginx openssl

COPY conf/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
