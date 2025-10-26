#!/bin/sh
set -e

# -----------------------------
# WordPress CLI Installation Script
# This script installs WP-CLI in the container
# -----------------------------

# -----------------------------
# Install WP-CLI using the official method
# -----------------------------
echo " Installing WP-CLI..."

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# -----------------------------
# Verify installation
# -----------------------------
wp --allow-root --version

echo " WP-CLI installed successfully"
