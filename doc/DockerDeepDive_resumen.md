# Docker Deep Dive



### 1: Contenedores desde 30,000 pies de altura

**Introducción y contexto histórico**

Los contenedores se han consolidado como una tecnología fundamental en el mundo de la informática moderna. Este capítulo explica por qué existen los contenedores, qué ventajas ofrecen y dónde se pueden aplicar.

**Los malos viejos tiempos**

Históricamente, las aplicaciones empresariales son críticas: su falla puede significar la caída o quiebra de la empresa. Tradicionalmente, cada aplicación se ejecutaba en un servidor físico dedicado, debido a limitaciones técnicas de los sistemas operativos (Windows, Linux) que impedían correr múltiples aplicaciones en un solo servidor de forma segura.

Esto generaba que cada nueva aplicación implicara comprar un servidor nuevo y sobredimensionado, debido a la incertidumbre sobre los requisitos de rendimiento. Como resultado, se desperdiciaba mucho capital y recursos, con servidores operando a solo un 5–10% de su capacidad.

**¡Hola VMware!**

VMware revolucionó este panorama con las máquinas virtuales (VMs), que permitían ejecutar múltiples aplicaciones seguras en un mismo servidor al virtualizar el hardware. Esto aumentó la eficiencia y redujo la necesidad de adquirir nuevos servidores.

**Limitaciones de las máquinas virtuales (VMs)**

Aunque las VMs aportaron mejoras, tienen inconvenientes:

* Cada VM requiere un sistema operativo (OS) completo, consumiendo recursos (CPU, RAM) que podrían destinarse a las aplicaciones.
* Cada OS requiere mantenimiento, parches y a veces licencias, aumentando costos y complejidad.
* Las VMs son lentas para arrancar.
* La portabilidad entre hipervisores y nubes no es óptima, dificultando la migración de cargas de trabajo.

**¡Hola contenedores!**

Las empresas tecnológicas a gran escala, como Google, comenzaron a usar contenedores para superar las limitaciones de las VMs. Un contenedor es conceptualmente similar a una VM, pero comparte el OS del host, en lugar de requerir uno propio.

Esto implica:

* Menor consumo de recursos (CPU, RAM, almacenamiento).
* Reducción de costos en licencias y mantenimiento.
* Arranque mucho más rápido.
* Mayor portabilidad: mover contenedores entre diferentes entornos (laptop, nube, VMs, hardware físico) es sencillo.

**Contenedores Linux**

El modelo moderno de contenedores se originó en Linux gracias a tecnologías del kernel como:

* **Namespaces**: aislamiento de recursos del sistema.
* **Control groups (cgroups)**: limitación y contabilización de recursos.
* **Capabilities**: control granular de privilegios.
* **Docker**: herramienta que simplifica el uso y gestión de contenedores.

Google fue un actor clave en desarrollar estas tecnologías. El ecosistema de contenedores modernos depende de estas bases.

Antes de Docker, los contenedores eran complejos y estaban fuera del alcance para la mayoría, pero Docker democratizó su uso.

**Tecnologías previas similares a contenedores**

Aunque Docker es el foco, existen tecnologías similares anteriores, como:

* System/360 (mainframes)
* BSD Jails
* Solaris Zones

**¡Hola Docker!**

Docker es la herramienta que hizo accesible el uso de contenedores Linux para usuarios y empresas, simplificando su creación y gestión.

**Docker y Windows**

Microsoft ha integrado soporte para contenedores en Windows, incluyendo:

* **Windows containers**: corren aplicaciones Windows y requieren un host con kernel Windows (Windows 10, 11 y versiones modernas de Windows Server).
* **Linux containers en Windows**: con WSL 2 (Windows Subsystem for Linux), cualquier host Windows puede correr contenedores Linux, lo que facilita desarrollo y pruebas.

Sin embargo, la mayoría de los contenedores siguen siendo Linux porque:

* Son más ligeros y rápidos.
* Existe un ecosistema más amplio de herramientas.

Este libro se centra en contenedores Linux.

**Windows containers vs Linux containers**

Los contenedores comparten el kernel del host:

* Aplicaciones Windows necesitan kernel Windows.
* Aplicaciones Linux necesitan kernel Linux.

Gracias a WSL 2, es posible ejecutar contenedores Linux en Windows.

**¿Contenedores en Mac?**

No existen contenedores nativos Mac OS, pero es común usar Docker Desktop que ejecuta contenedores Linux dentro de una VM Linux ligera. Esto es popular entre desarrolladores Mac.

**¿Y Kubernetes?**

Kubernetes es un sistema open-source desarrollado por Google que se ha convertido en el orquestador estándar para aplicaciones en contenedores.

* “Aplicación en contenedor” se refiere a una aplicación empaquetada y ejecutada como contenedor.
* Kubernetes usaba Docker como runtime por defecto, pero ahora, gracias a la Container Runtime Interface (CRI), puede usar otros runtimes, siendo **containerd** (la parte de Docker responsable de iniciar y detener contenedores) el más común.

---

Este resumen completo y detallado recoge todo el contenido importante del capítulo, manteniendo la terminología técnica precisa y el orden del original, para que puedas entender el contexto y funcionamiento fundamental de los contenedores y Docker. ¿Quieres que continúe con los siguientes capítulos de la misma forma?


---



Claro, aquí tienes un resumen exhaustivo y traducido al español del capítulo 2 “Docker” siguiendo el formato y criterios que me diste:

---

### 2: Docker

**Introducción: qué es Docker**

Docker es una palabra que puede referirse a dos cosas distintas pero relacionadas:

1. **Docker, Inc.**: la empresa que desarrolló y sigue evolucionando la tecnología.
2. **Docker**: la tecnología de contenedores en sí misma.

---

### Docker — Versión rápida (TL;DR)

Docker es un software que se ejecuta tanto en Linux como en Windows, diseñado para crear, gestionar y orquestar contenedores. Está compuesto por varias herramientas del proyecto open-source **Moby**. Docker, Inc. es la empresa que desarrolló esta tecnología y continúa facilitando su uso, especialmente para ejecutar código desde un portátil hasta la nube.

---

### Docker, Inc.

Docker, Inc. es una empresa tecnológica con sede en San Francisco, fundada por **Solomon Hykes**, desarrollador franco-estadounidense, que ya no forma parte de la compañía.

* Originalmente, Docker, Inc. era **dotCloud**, un proveedor de plataforma como servicio (**PaaS**).
* DotCloud estaba construido sobre contenedores Linux y desarrolló internamente una herramienta para crear y gestionar contenedores llamada **Docker**.
* El nombre "Docker" proviene del término británico para "estibador" (dock worker), la persona que carga y descarga mercancía en los barcos.
* En 2013, dotCloud eliminó su negocio PaaS, se renombró como Docker, Inc. y enfocó todos sus esfuerzos en promover la tecnología de contenedores Docker.
* En adelante, en este libro **Docker, Inc.** se usará para referirse a la empresa, y **Docker** para la tecnología.

---

### La tecnología Docker

Docker como tecnología se compone principalmente de tres elementos clave:

1. **El runtime** (tiempo de ejecución).
2. **El daemon** (motor o engine).
3. **El orquestador**.

---

#### El runtime

El runtime es la capa más baja, responsable de iniciar y detener contenedores, construyendo elementos esenciales del sistema operativo como **namespaces** y **cgroups**.

* Docker usa un modelo de runtime por niveles:

  * **Runtime de bajo nivel:** **runc**. Es la implementación de referencia de la especificación **OCI runtime-spec** de la **Open Containers Initiative (OCI)**. Interactúa directamente con el OS y arranca o detiene contenedores. Cada contenedor se ejecuta en una instancia de **runc**.
  * **Runtime de alto nivel:** **containerd**. Administra el ciclo de vida completo del contenedor, incluyendo la descarga de imágenes y el manejo de instancias de **runc**. Es un proyecto graduado por la **Cloud Native Computing Foundation (CNCF)**, utilizado tanto por Docker como por Kubernetes.

En una instalación típica, **containerd** está siempre activo y coordina con **runc** para arrancar y detener contenedores, mientras que **runc** es efímero y termina una vez el contenedor inicia.

---

#### El daemon de Docker

El **Docker daemon** (**dockerd**) funciona encima de **containerd**, realizando tareas de alto nivel:

* Expone la **Docker API**.
* Gestiona imágenes, volúmenes y redes.
* Facilita una interfaz estándar y accesible que abstrae la complejidad del runtime.

---

#### El orquestador: Docker Swarm

Docker soporta de forma nativa la gestión de clústeres (grupos de nodos) llamados **swarms** mediante **Docker Swarm**.

* Es sencillo de usar y ampliamente adoptado en producción.
* Más fácil de instalar y gestionar que Kubernetes.
* Sin embargo, carece de muchas funcionalidades avanzadas y del ecosistema robusto que ofrece Kubernetes.

---

### La Open Container Initiative (OCI)

La **Open Containers Initiative (OCI)** es un organismo de gobernanza que busca estandarizar componentes clave de bajo nivel en la infraestructura de contenedores, especialmente:

* El formato de imagen (**image format**).
* El runtime del contenedor (**container runtime**).

---

#### Historia y contexto

* Al crecer la adopción de Docker, surgieron tensiones y competencia con proyectos como **CoreOS**, que promovía un estándar alternativo llamado **appc** y su runtime **rkt**.
* La existencia de múltiples estándares fragmentaba el ecosistema, generando confusión y ralentizando la adopción.
* Como respuesta, todas las partes se unieron para formar la **OCI**, un consejo ágil para gobernar los estándares de contenedores.

---

#### Especificaciones OCI publicadas

Actualmente, la OCI ha lanzado tres especificaciones principales:

* **image-spec**: define el formato estándar para las imágenes de contenedores.
* **runtime-spec**: define el estándar para el runtime del contenedor.
* **distribution-spec**: especifica la distribución de imágenes.

Estas especificaciones son comparables a estandarizar el tamaño de las vías de tren, permitiendo que fabricantes independientes construyan trenes y vagones compatibles, asegurando interoperabilidad.

* Las versiones modernas de Docker y Docker Hub cumplen con estas especificaciones.
* La OCI funciona bajo la **Linux Foundation**.



---


### 3: Instalando Docker

Existen muchas formas y lugares para instalar Docker: en Windows, Mac y Linux.
Puedes instalarlo en la nube, en servidores locales (on premises) o en tu portátil. También hay instalaciones manuales, mediante scripts o con asistentes gráficos…

Pero no dejes que eso te intimide. Todas son realmente fáciles, y una simple búsqueda de “how to install docker on `<inserta tu opción aquí>`” revelará instrucciones actualizadas y fáciles de seguir.
Por ello, no gastaremos demasiado espacio aquí. Cubriremos lo siguiente:

* **Docker Desktop**
  – Windows
  – MacOS
* **Multipass**
* Instalaciones de servidor en:
  – Linux
* **Play with Docker**

---

### **Docker Desktop**

Docker Desktop es una aplicación de escritorio de Docker, Inc. que facilita enormemente el trabajo con contenedores. Incluye el motor de Docker (Docker engine), una interfaz gráfica pulida y un sistema de extensiones con un marketplace.
Estas extensiones añaden funciones muy útiles, como el escaneo de imágenes en busca de vulnerabilidades o la gestión sencilla de imágenes y espacio en disco.

Docker Desktop es gratuito para fines educativos, pero deberás pagar si lo usas para trabajo y tu empresa tiene más de 250 empleados o más de 10 millones USD de ingresos anuales.

Funciona en versiones de 64 bits de Windows 10, Windows 11, MacOS y Linux.

Una vez instalado, tendrás un entorno Docker completamente funcional ideal para desarrollo, pruebas y aprendizaje. Incluye **Docker Compose** y hasta permite habilitar un clúster Kubernetes de un solo nodo para fines de estudio.

En Windows, Docker Desktop puede ejecutar contenedores nativos de Windows y contenedores Linux.
En Mac y Linux, solo puede ejecutar contenedores Linux.

A continuación, veremos el proceso de instalación en Windows y MacOS.

---

#### **Requisitos previos para Windows**

Docker Desktop en Windows requiere:

* Versión de 64 bits de Windows 10/11
* Soporte de virtualización por hardware habilitado en la BIOS del sistema
* **WSL 2** (Windows Subsystem for Linux, versión 2)

⚠️ Ten mucho cuidado al cambiar configuraciones en la BIOS.

---

#### **Instalando Docker Desktop en Windows 10 y 11**

Busca en internet o pide a tu asistente de IA cómo “install Docker Desktop on Windows”. Esto te llevará a la página de descarga correspondiente, donde podrás obtener el instalador y seguir las instrucciones.
Es posible que debas instalar y habilitar el backend WSL 2.

Una vez completada la instalación, puede que tengas que iniciar manualmente Docker Desktop desde el menú Inicio de Windows. Puede tardar un minuto en arrancar; podrás seguir el progreso gracias al icono animado de la ballena en la barra de tareas.

Cuando esté en ejecución, abre una terminal y ejecuta:

```bash
$ docker version
```

**Salida de ejemplo:**

```
Client:
Cloud integration: v1.0.31
Version: 20.10.23
API version: 1.41
Go version: go1.18.10
Git commit: 7155243
Built: Thu Jan 19 01:20:44 2023
OS/Arch: linux/amd64
Context: default
Experimental: true

Server:
Engine:
Version: 20.10.23
<Snip>
OS/Arch: linux/amd64
Experimental: true
```

Observa que el **Server** muestra `OS/Arch: linux/amd64`. Esto se debe a que la instalación por defecto trabaja con contenedores Linux.

Puedes cambiar a contenedores Windows haciendo clic derecho en el icono de la ballena en el área de notificaciones y seleccionando **Switch to Windows containers…**.
Los contenedores Linux seguirán ejecutándose en segundo plano, pero no podrás gestionarlos hasta que vuelvas al modo Linux.

Al ejecutar nuevamente `docker version`, en la sección **Server** verás `OS/Arch: windows/amd64`.

Ahora podrás ejecutar y gestionar contenedores que corran aplicaciones Windows.
¡Listo! Docker está funcionando en tu máquina Windows.

---

### **Instalando Docker Desktop en Mac**

Docker Desktop para Mac es equivalente al de Windows: un producto empaquetado con interfaz gráfica que instala Docker en un único motor, ideal para desarrollo local. También permite activar un clúster Kubernetes de un solo nodo.

En Mac, Docker Desktop instala todos los componentes de Docker en una **máquina virtual ligera de Linux (VM)** que expone la API de forma transparente al entorno local.
Esto significa que puedes usar los comandos Docker habituales en tu terminal sin notar que todo corre dentro de una VM Linux.
Por esta razón, en Mac solo se pueden usar contenedores Linux, lo cual está bien ya que la mayoría del trabajo con contenedores ocurre en Linux.

La forma más sencilla de instalarlo es buscar “install Docker Desktop on MacOS” y seguir el instalador.

Tras instalar, quizá tengas que iniciarlo desde **Launchpad**. Al arrancar, verás el icono animado de la ballena en la barra superior.
Abre una terminal y ejecuta:

```bash
$ docker version
```

**Salida de ejemplo:**

```
Client:
Cloud integration: v1.0.31
Version: 23.0.5
API version: 1.42
<Snip>
OS/Arch: darwin/arm64
Context: desktop-linux

Server: Docker Desktop 4.19.0 (106363)
Engine:
Version: dev
API version: 1.43 (minimum version 1.12)
<Snip>
OS/Arch: linux/arm64
Experimental: false
...
```

El cliente (`Client`) es una aplicación nativa para MacOS (Darwin kernel), mientras que el servidor (`Server`) corre dentro de la VM Linux.

Ya puedes usar Docker en Mac.

---

### **Instalando Docker con Multipass**

Multipass es una herramienta gratuita para crear VMs Linux tipo “cloud” en Linux, Mac o Windows. Es ideal para pruebas rápidas de Docker.

Instálalo desde: [https://multipass.run/install](https://multipass.run/install)

Comandos básicos:

```bash
$ multipass launch
$ multipass ls
$ multipass shell
```

Para crear una VM llamada `node1` con Docker preinstalado:

```bash
$ multipass launch docker --name node1
```

Lista las VMs:

```bash
$ multipass ls
```

Conéctate a la VM:

```bash
$ multipass shell node1
```

Para eliminarla:

```bash
$ multipass delete node1
$ multipass purge
```

---

### **Instalando Docker en Linux**

Hay múltiples formas de hacerlo; la recomendada es consultar la documentación más reciente.
Ejemplo en Ubuntu 22.04 LTS:

1. Eliminar paquetes existentes:

```bash
$ sudo apt-get remove docker docker-engine docker.io containerd runc
```

2. Actualizar e instalar dependencias:

```bash
$ sudo apt-get update
$ sudo apt-get install ca-certificates curl gnupg
```

3. Añadir clave GPG de Docker:

```bash
$ sudo install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

4. Configurar el repositorio:

```bash
$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5. Instalar desde el repo oficial:

```bash
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Verifica:

```bash
$ sudo docker --version
$ sudo docker info
```

---

### **Play with Docker**

**Play with Docker (PWD)** es un entorno Docker en línea y gratuito con duración de 4 horas, que permite crear varios nodos y hasta formar un **swarm**.
Entra en: [https://labs.play-with-docker.com/](https://labs.play-with-docker.com/)

---



### 3: Instalando Docker

Docker se puede instalar de muchas formas y en múltiples entornos: Windows, Mac, Linux, servidores locales (on premises), portátiles o incluso en la nube. Además, las instalaciones pueden ser manuales, por scripts o con asistentes gráficos.

No es necesario complicarse: basta con buscar “how to install docker on `<tu plataforma>`” para encontrar instrucciones actualizadas y fáciles. Aquí cubriremos lo esencial:

* Docker Desktop (Windows y MacOS)
* Multipass
* Instalación en servidores Linux
* Play with Docker (entorno online)

---

### Docker Desktop

Docker Desktop es la aplicación oficial de escritorio de Docker, Inc., que facilita trabajar con contenedores. Incluye:

* Docker Engine
* Interfaz gráfica pulida
* Sistema de extensiones con marketplace (para escaneo de imágenes, gestión de espacio, etc.)

**Licencia:** Gratis para educación y uso personal; para empresas grandes (más de 250 empleados o más de 10M USD en ingresos) es de pago.

**Plataformas soportadas:** Windows 10/11 64 bits, MacOS, Linux.

**Características:**

* Entorno Docker completo para desarrollo, pruebas y aprendizaje.
* Incluye Docker Compose.
* Permite activar un clúster Kubernetes de un solo nodo para estudio.
* En Windows puede ejecutar contenedores Linux y Windows.
* En Mac y Linux solo contenedores Linux.

---

#### Requisitos previos para Windows

* Windows 10 o 11 64 bits.
* Virtualización por hardware habilitada en BIOS (cuidado al modificarla).
* WSL 2 (Windows Subsystem for Linux versión 2).

---

#### Instalación en Windows 10 y 11

* Busca “install Docker Desktop on Windows” para descargar el instalador.

* Puede que necesites instalar y habilitar WSL 2.

* Inicia Docker Desktop desde el menú Inicio; la ballena animada indica progreso.

* Verifica con:

  ```bash
  $ docker version
  ```

* Por defecto, Docker corre contenedores Linux (`OS/Arch: linux/amd64`).

* Para cambiar a contenedores Windows, clic derecho en icono de ballena > **Switch to Windows containers…**.

* Ejecutando de nuevo `docker version` verás `OS/Arch: windows/amd64`.

* Ya puedes gestionar contenedores Windows.

---

#### Instalación en MacOS

* Docker Desktop para Mac instala todos los componentes dentro de una VM ligera Linux que expone la API localmente.

* Solo puede correr contenedores Linux.

* Busca “install Docker Desktop on MacOS” y sigue el instalador.

* Inicia desde Launchpad; verás la ballena animada en la barra superior.

* Verifica con:

  ```bash
  $ docker version
  ```

* Cliente es nativo MacOS (`darwin/arm64`), servidor corre en VM Linux (`linux/arm64`).

* Ya puedes usar Docker en Mac.

---

### Instalando Docker con Multipass

Multipass es una herramienta gratuita para crear VMs Linux tipo cloud en Linux, Mac o Windows, ideal para pruebas rápidas con Docker.

* Web oficial: [https://multipass.run/install](https://multipass.run/install)

Comandos básicos:

```bash
$ multipass launch
$ multipass ls
$ multipass shell
```

Para crear VM con Docker preinstalado:

```bash
$ multipass launch docker --name node1
```

Conéctate a la VM:

```bash
$ multipass shell node1
```

Eliminar VM:

```bash
$ multipass delete node1
$ multipass purge
```

---

### Instalando Docker en Linux

La recomendación es seguir siempre la documentación oficial más reciente.

Ejemplo para Ubuntu 22.04 LTS:

1. Elimina posibles instalaciones previas:

   ```bash
   $ sudo apt-get remove docker docker-engine docker.io containerd runc
   ```

2. Actualiza e instala dependencias:

   ```bash
   $ sudo apt-get update
   $ sudo apt-get install ca-certificates curl gnupg
   ```

3. Añade la clave GPG de Docker:

   ```bash
   $ sudo install -m 0755 -d /etc/apt/keyrings
   $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   $ sudo chmod a+r /etc/apt/keyrings/docker.gpg
   ```

4. Configura el repositorio Docker:

   ```bash
   $ echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
   https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
   | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. Instala Docker y sus componentes:

   ```bash
   $ sudo apt-get update
   $ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

Verifica instalación:

```bash
$ sudo docker --version
$ sudo docker info
```

---



### 4: The big picture

El objetivo de este capítulo es ofrecerte una visión general rápida de qué trata Docker antes de profundizar en capítulos posteriores.
Dividiremos este capítulo en dos partes:

* La perspectiva de Ops
* La perspectiva de Dev

En la sección de Ops, descargaremos una imagen, iniciaremos un contenedor nuevo, accederemos a él, ejecutaremos un comando dentro y luego lo destruiremos.
En la sección de Dev, nos enfocaremos más en la aplicación. Clonaremos código desde GitHub, inspeccionaremos un Dockerfile, contenedorizaremos la app y la ejecutaremos como contenedor.

Estas dos secciones te darán una buena idea de qué es Docker y cómo encajan sus componentes principales. Se recomienda leer ambas para obtener las perspectivas de desarrollo y operaciones. ¿DevOps, alguien?

No te preocupes si algunos conceptos son nuevos. No pretendemos hacerte experto en este capítulo, sino darte una sensación general para que, cuando entremos en detalles, ya tengas una idea clara del panorama.

Para seguir los ejemplos, solo necesitas un host Docker con conexión a internet. Recomiendo Docker Desktop para Mac o Windows, aunque los ejemplos funcionan en cualquier sistema con Docker instalado. Usaremos ejemplos tanto con contenedores Linux como Windows.

Si no puedes instalar software ni tienes acceso a nube pública, otra excelente opción es **Play With Docker (PWD)**, un entorno Docker online y gratuito de 4 horas. Solo apunta tu navegador a [https://labs.play-with-docker.com/](https://labs.play-with-docker.com/) y listo (necesitarás una cuenta Docker Hub o GitHub para iniciar sesión).

En este capítulo, usaremos indistintamente “Docker host” o “Docker node” para referirnos al sistema donde corre Docker.

---

#### The Ops Perspective

Al instalar Docker, obtienes dos componentes principales:

* El cliente Docker
* El motor Docker (a veces llamado “daemon”)

El motor implementa el runtime, API y todo lo necesario para ejecutar contenedores.
En una instalación típica de Linux, el cliente se comunica con el daemon vía un socket local Unix en `/var/run/docker.sock`. En Windows, usa un pipe nombrado `npipe:////./pipe/docker_engine`.

Para verificar que cliente y daemon están activos y comunicándose, usa:

```bash
$ docker version
```

**Ejemplo de salida:**

```
Client: Docker Engine - Community
Version: 24.0.0
API version: 1.43
Go version: go1.20.4
Git commit: 98fdcd7
Built: Mon May 15 18:48:45 2023
OS/Arch: linux/arm64
Context: default

Server: Docker Engine - Community
Engine:
Version: 24.0.0
API version: 1.43 (minimum version 1.12)
Go version: go1.20.4
Git commit: 1331b8c
Built: Mon May 15 18:48:45 2023
OS/Arch: linux/arm64
Experimental: false
```

Si obtienes respuesta tanto del cliente como del servidor, estás listo para continuar.

Si usas Linux y recibes error del servidor, verifica que Docker esté corriendo y prueba con `sudo docker version`. Si funciona con `sudo`, agrega tu usuario al grupo `docker` o antepón siempre `sudo` a los comandos Docker.

---

#### Imágenes

Piensa en una imagen Docker como un objeto que contiene un sistema de archivos de un OS, una aplicación y todas sus dependencias. Para operaciones, es parecido a una plantilla de máquina virtual (VM). Para desarrollo, es como una clase en programación.

Ejecuta:

```bash
$ docker images
```

Si es un host Docker nuevo o PWD, probablemente no veas imágenes listadas.

Para obtener imágenes en tu host Docker, debes “tirarlas” (pull). Por ejemplo, baja la imagen de Ubuntu:

```bash
$ docker pull ubuntu:latest
```

Verás que Docker descarga varias capas y finaliza mostrando la imagen. Luego:

```bash
$ docker images
```

Deberías ver algo así:

```
REPOSITORY TAG IMAGE ID CREATED SIZE
ubuntu latest dfd64a3b4296 1 minute ago 106MB
```

Más adelante profundizaremos dónde se almacena la imagen y qué contiene. Por ahora, basta saber que incluye una versión reducida del sistema de archivos de Ubuntu y utilidades básicas.

Si bajas una imagen de una app, como `nginx:latest`, tendrás el OS mínimo y el código para correr NGINX.

Cada imagen tiene un ID único. Puedes usar el nombre o la parte inicial del ID para referenciarla, mientras sea único.

---

#### Contenedores

Con una imagen local, puedes ejecutar un contenedor con:

```bash
$ docker run -it ubuntu:latest /bin/bash
```

Fíjate que tu prompt cambia porque ahora estás dentro del contenedor con una shell interactiva (`-it`).

`docker run` arranca un contenedor nuevo. Las opciones `-it` indican que sea interactivo y que conecte tu terminal con el contenedor. El contenedor se basa en la imagen `ubuntu:latest` y corre el comando `/bin/bash`.

Dentro, corre:

```bash
root@6dc20d508db0:/# ps -elf
```

Verás dos procesos:

* PID 1: el `/bin/bash` que lanzaste
* PID 9: el comando `ps -elf` que acabas de ejecutar

El resto de procesos del host no están dentro del contenedor, que es un entorno aislado.

Presiona `Ctrl-P Q` para salir del contenedor sin detenerlo. Volverás a la terminal del host.

Ejecuta en el host:

```bash
$ docker ps
```

Verás tu contenedor aún corriendo, con su nombre generado, cuánto tiempo lleva activo, etc.

---

#### Volver a entrar a un contenedor

Puedes reconectarte a un contenedor en ejecución con:

```bash
$ docker exec -it <nombre_o_id_del_contenedor> bash
```

Ejemplo:

```bash
$ docker exec -it vigilant_borg bash
```

Cambiará tu prompt al del contenedor otra vez.

Sal con `Ctrl-P Q` y vuelve al host.

Para detener y eliminar el contenedor:

```bash
$ docker stop vigilant_borg
$ docker rm vigilant_borg
```

Confirma que el contenedor desapareció con:

```bash
$ docker ps -a
```

¡Felicidades! Acabas de bajar una imagen, lanzar un contenedor, conectarte, ejecutar comandos, detenerlo y eliminarlo.

---

#### The Dev Perspective

Los contenedores giran en torno a las aplicaciones.
Vamos a clonar una app, ver su Dockerfile, construirla y correrla como contenedor.

Clona la app Node.js desde GitHub:

```bash
$ git clone https://github.com/nigelpoulton/psweb.git
```

Entra al directorio y lista archivos:

```bash
$ cd psweb
$ ls -l
```

Verás archivos como `Dockerfile`, `app.js`, `package.json`, etc.

El Dockerfile contiene instrucciones para construir la imagen:

```Dockerfile
FROM alpine
LABEL maintainer="nigelpoulton@hotmail.com"
RUN apk add --update nodejs nodejs-npm
COPY . /src
WORKDIR /src
RUN npm install
EXPOSE 8080
ENTRYPOINT ["node", "./app.js"]
```

Cada línea indica a Docker qué hacer: partir de Alpine Linux, instalar Node.js, copiar archivos, instalar dependencias, exponer el puerto 8080 y lanzar la app.

Ahora construye la imagen con:

```bash
$ docker build -t test:latest .
```

Este comando crea una imagen llamada `test` con la etiqueta `latest` usando el Dockerfile del directorio actual (`.`).

---

### Play with Docker (PWD)

**Play with Docker** es un entorno Docker online gratuito, con sesiones de hasta 4 horas, que permite crear múltiples nodos y formar un **swarm**.

Sitio web: [https://labs.play-with-docker.com/](https://labs.play-with-docker.com/)

---





