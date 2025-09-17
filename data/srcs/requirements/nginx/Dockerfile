# Use a lightweight version of Debian as the base image
FROM debian:bullseye-slim

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Nginx and clean up package cache to reduce image size
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy custom Nginx configuration file
 COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to allow HTTP traffic
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
