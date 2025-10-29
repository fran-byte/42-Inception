FROM alpine:3.21
# --------------------------------------------------
# Base Image: Alpine 3.21 (from Docker Hub)
# --------------------------------------------------

# --------------------------------------------------
# Updating APK and installing Redis
# --------------------------------------------------
RUN apk update && apk add --no-cache redis

# --------------------------------------------------
# Setting default command to start Redis
# --------------------------------------------------
CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
