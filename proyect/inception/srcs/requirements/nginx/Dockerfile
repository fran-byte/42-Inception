FROM alpine:3.21

# --------------------------------------------------
# Base Image: Alpine 3.21 (from Docker Hub)
# --------------------------------------------------

# --------------------------------------------------
# Installing required packages (nginx, openssl)
# --------------------------------------------------
RUN apk update && apk add --no-cache nginx openssl

# --------------------------------------------------
# Copying global Nginx configuration
# --------------------------------------------------
COPY conf/nginx.conf /etc/nginx/nginx.conf

# --------------------------------------------------
# Copying server block configuration
# --------------------------------------------------
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# --------------------------------------------------
# Exposing HTTPS port (443)
# --------------------------------------------------
EXPOSE 443

# --------------------------------------------------
# Starting Nginx in foreground mode
# --------------------------------------------------
CMD ["nginx", "-g", "daemon off;"]
