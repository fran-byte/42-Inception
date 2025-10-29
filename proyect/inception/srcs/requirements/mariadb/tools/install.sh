#!/bin/sh
set -e

# --------------------------------------------------
# MariaDB Install Script: Running during Docker image build
# --------------------------------------------------

# --------------------------------------------------
# Setting up MariaDB directories
# --------------------------------------------------
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# --------------------------------------------------
# Initializing MariaDB database (build-time only)
# --------------------------------------------------
mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# --------------------------------------------------
# MariaDB setup completed during build
# --------------------------------------------------
