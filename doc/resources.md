# 42-Inception - Índice de Recursos Esenciales

## 1. Fundamentos de Docker  
*Conceptos esenciales para entender la virtualización con contenedores: arquitectura Docker, creación de imágenes con Dockerfile, gestión de ciclos de vida de contenedores, y diferencias clave con máquinas virtuales tradicionales.*  
- [Documentación Oficial Docker](https://docs.docker.com/)  
- [Docker Deep Dive (Nigel Poulton)](https://www.amazon.com/Docker-Deep-Dive-Nigel-Poulton/dp/1521822808)  

## 2. Docker Compose  
*Orquestación avanzada de múltiples servicios: configuración de dependencias entre contenedores, gestión de redes aisladas, escalamiento de servicios, y optimización del archivo docker-compose.yml para entornos complejos.*  
- [Guía Oficial Docker Compose](https://docs.docker.com/compose/)  
- [Tutorial: Multi-Container Apps](https://www.youtube.com/watch?v=HG6yIjZapSA)  

## 3. NGINX + TLS  
*Configuración segura de servidor web: implementación de TLS 1.2/1.3, generación de certificados autofirmados, optimización como reverse proxy para aplicaciones PHP, y hardening de configuraciones para cumplir con estándares de seguridad.*  
- [Configuración HTTPS en NGINX](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)  
- [Generación de Certificados Autofirmados](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)  

## 4. WordPress + PHP-FPM  
*Implementación óptima de CMS: instalación manual sin dependencias externas, configuración de PHP-FPM para procesamiento eficiente, gestión de plugins y temas, y conexión segura con base de datos MariaDB.*  
- [Instalación Manual WordPress](https://make.wordpress.org/hosting/handbook/server-environment/)  
- [Configuración PHP-FPM](https://www.php.net/manual/en/install.fpm.configuration.php)  

## 5. MariaDB en Docker  
*Gestión de bases de datos en contenedores: creación segura de usuarios y privilegios, configuración de almacenamiento persistente con volúmenes, optimización de consultas, y prácticas de backup/recovery para datos críticos.*  
- [Imagen Oficial MariaDB](https://hub.docker.com/_/mariadb)  
- [Seguridad en MariaDB](https://mariadb.com/kb/en/security-overview/)  

## 6. Seguridad y Variables de Entorno  
*Protección de infraestructura: implementación de Docker Secrets para credenciales, gestión centralizada con archivos .env, prevención de hardcoding en Dockerfiles, y prácticas de hardening para contenedores.*  
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)  
- [Manejo de .env Files](https://docs.docker.com/compose/environment-variables/#the-env-file)  

## 7. Docker Networking  
*Comunicación segura entre servicios: configuración de redes puente aisladas, resolución DNS entre contenedores, exposición selectiva de puertos, y diagnóstico de problemas de conectividad en entornos multi-container.*  
- [Tipos de Redes Docker](https://docs.docker.com/network/)  
- [Comunicación entre Contenedores](https://docs.docker.com/network/links/)  

## 8. Makefile para Docker  
*Automatización de flujos de trabajo: creación de targets para construcción, despliegue y limpieza, integración con docker-compose, gestión de dependencias entre servicios, y simplificación de comandos complejos.*  
- [Tutorial Makefile](https://makefiletutorial.com/)  
- [Ejemplos Docker + Makefile](https://github.com/docker/awesome-compose/tree/master/nginx-golang)  

## 9. Volúmenes y Persistencia  
*Gestión de almacenamiento persistente: diferencias entre volúmenes y bind mounts, configuración de permisos, estrategias de backup para bases de datos, y recuperación de datos en fallos de contenedores.*  
- [Manejo de Volúmenes](https://docs.docker.com/storage/volumes/)  
- [Backup de Datos en Docker](https://docs.docker.com/storage/volumes/#back-up-restore-or-migrate-data-volumes)  

## 10. Bonus: Servicios Adicionales  
*Implementación de funcionalidades avanzadas: integración de Redis para caché de WordPress, configuración segura de servidores FTP, despliegue de sitios estáticos modernos, y justificación de componentes adicionales durante la defensa.*  
- **Redis**: [WordPress + Redis Cache](https://redis.io/docs/connect/clients/php/)  
- **FTP**: [vsftpd en Docker](https://github.com/fauria/docker-vsftpd)  
- **Adminer**: [Docker Hub Adminer](https://hub.docker.com/_/adminer)  

---
