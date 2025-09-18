FROM debian:bookworm-slim

# Instalar Nginx
RUN apt update && apt install -y nginx && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copiar configuración personalizada
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copiar certificados SSL
COPY certs/selfsigned.crt /etc/ssl/certs/selfsigned.crt
COPY certs/selfsigned.key /etc/ssl/private/selfsigned.key

# Exponer puertos HTTP y HTTPS
EXPOSE 80
EXPOSE 443

# Ejecutar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
