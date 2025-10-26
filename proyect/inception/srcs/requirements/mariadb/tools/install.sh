#!/bin/sh
set -e

# -----------------------------
# MariaDB Install Script
# Runs during Docker image build
# -----------------------------

echo "---> Setting up MariaDB directories..."

# -----------------------------
# Create directories and set permissions
# -----------------------------
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# -----------------------------
# Initialize database (build-time only)
# -----------------------------
mariadb-install-db --user=mysql --datadir=/var/lib/mysql

echo "---> MariaDB setup completed during build."
