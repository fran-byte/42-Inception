# OS de este contenedor
FROM debian:bullseye-slim

# Instalando MariaDB y cliente
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Creando directorio de almacenamiento de datos
# Asignando permisos al usuario y al grupo mysql
# que ejecutará el servicio
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Copiar el script de instalación personalizado
COPY tools/install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh

# Ejecutar el script al iniciar el contenedor
CMD ["install.sh"]
