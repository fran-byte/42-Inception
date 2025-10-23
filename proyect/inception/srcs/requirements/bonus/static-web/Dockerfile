FROM nginx:alpine

# Copiar contenido estático
COPY ./html /usr/share/nginx/html
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Crear directorios para certificados SSL
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Los certificados se montarán como volúmenes en docker-compose.yml

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
