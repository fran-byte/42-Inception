#!/bin/sh
set -e

# --------------------------------------------------
# WordPress CLI Installation Script
# Installs WP-CLI in the container
# --------------------------------------------------

# --------------------------------------------------
# Install WP-CLI using the official method
# --------------------------------------------------
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# --------------------------------------------------
# Verify WP-CLI installation
# --------------------------------------------------
wp --allow-root --version

# --------------------------------------------------
# Installation completed
# --------------------------------------------------
