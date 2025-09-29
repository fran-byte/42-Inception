# Static Web Bonus Service
# -----------------------------
FROM nginx:alpine

# -----------------------------
# Remove default nginx website
# -----------------------------
RUN rm -rf /usr/share/nginx/html/*

# -----------------------------
# Copy static website and nginx config
# -----------------------------
COPY html /usr/share/nginx/html
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# -----------------------------
# Set proper permissions
# -----------------------------
RUN chmod -R 755 /usr/share/nginx/html

# Nginx runs automatically as PID 1
EXPOSE 80
