#!/bin/sh

# Install script: sets up MariaDB directories and initializes the database

set -e

echo "---> Inicializing MariaDB during build..."

# -----------------------------
# Create directories and set permissions
# -----------------------------
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

# -----------------------------
# Initialize database
# -----------------------------
mysql_install_db --user=mysql --datadir=/var/lib/mysql

echo " MariaDB ready during build."
