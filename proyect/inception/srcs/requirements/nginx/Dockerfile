# Ngnix Docker file
# -----------------------------
# Image Base From Docker Hub
# -----------------------------

FROM alpine:3.21

# -----------------------------
# Install required packages
# -----------------------------
RUN apk update && apk add --no-cache nginx openssl

# -----------------------------
# Copy global Nginx configuration
# -----------------------------
COPY conf/nginx.conf /etc/nginx/nginx.conf

# -----------------------------
# Copy server block configuration
# -----------------------------
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# -----------------------------
# Expose HTTPS port
# -----------------------------
EXPOSE 443

# -----------------------------
# Start Nginx in foreground
# -----------------------------
CMD ["nginx", "-g", "daemon off;"]
