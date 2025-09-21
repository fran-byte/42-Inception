# Dockerfile (mariadb) 

1️⃣ Base de la imagen

FROM alpine:3.18

Se usa Alpine Linux 3.18 como base.

Alpine es muy ligera (~5 MB), ideal para contenedores pequeños y seguros.



---

2️⃣ Instalación de MariaDB

RUN apk update && apk add mariadb mariadb-client

apk update → Actualiza los repositorios de Alpine.

apk add mariadb mariadb-client → Instala el servidor MariaDB y el cliente para conexiones desde la línea de comandos.



---

3️⃣ Crear directorios necesarios

RUN mkdir -p /var/lib/mysql /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld
RUN chmod -R 755 /var/lib/mysql /run/mysqld

/var/lib/mysql → Carpeta donde se guardan los datos de la base de datos.

/run/mysqld → Carpeta para el socket y archivos temporales de MariaDB.

Se cambia el propietario a mysql:mysql para que el servidor tenga permisos de lectura/escritura.

Se aplican permisos 755 (lectura/ejecución para todos, escritura para el propietario).



---

4️⃣ Copiar el script de entrada

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

entrypoint.sh es el script que se ejecuta cuando inicia el contenedor.

Normalmente inicializa la base de datos si es la primera vez, crea usuarios y arranca el servidor MariaDB.

Se hace ejecutable con chmod +x.



---

5️⃣ Exposición de puertos

EXPOSE 3306

Expone el puerto 3306, que es el puerto por defecto de MariaDB, para que otros contenedores o el host puedan conectarse.



---

6️⃣ Punto de entrada

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

Define que al iniciar el contenedor, se ejecute siempre el script entrypoint.sh.

Esto asegura que MariaDB se inicialice correctamente y arranque automáticamente.



---

✅ Resumen:
Este Dockerfile crea un contenedor ligero de MariaDB, con directorios preparados, permisos correctos y un script de inicio que asegura que la base de datos esté lista al arrancar el contenedor.

  
