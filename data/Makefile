# Variables
DC = docker compose                   # Alias para el comando 'docker compose'
DC_FILE = ./srcs/docker-compose.yml   # Ruta al archivo docker-compose que se usará

# Declaración de targets como phony (no son archivos)
.PHONY: up stop rm clean purge restart re logs

# Levanta los servicios
up:
        @mkdir -p ./data/db ./data/wp       # Crea carpetas persistentes para la base de datos y WordPress
        @$(DC) -f $(DC_FILE) up --build -d  # Construye y levanta los contenedores en segundo plano

# Detiene los contenedores sin eliminarlos
stop:
        @$(DC) -f $(DC_FILE) stop

# Elimina los contenedores (pero conserva volúmenes y datos)
rm:
        @$(DC) -f $(DC_FILE) down

# Elimina contenedores y volúmenes
clean:
        @$(DC) -f $(DC_FILE) down -v

# Limpieza total: contenedores, volúmenes, carpetas locales y caché de Docker
purge: clean
        @rm -rf ./data/db ./data/wp  # Borra carpetas locales de datos
         @docker system prune -a -f  # Elimina imágenes, contenedores y redes no usadas

# Reinicia todo desde cero
restart: clean up
