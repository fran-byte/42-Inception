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


Claro, aquí tienes un resumen exhaustivo y detallado en español del contenido del capítulo sobre la arquitectura y evolución del motor Docker, manteniendo toda la terminología técnica clave en inglés con su referencia:

---

# Part 2

### Arquitectura antigua de Docker y eliminación de LXC

En los primeros tiempos, Docker dependía de LXC (Linux Containers) para gestionar los contenedores. Esta dependencia fue problemática por dos razones principales:

* **LXC es específico de Linux**, lo que limitaba la capacidad de Docker para ser multiplataforma.
* Confiar en una herramienta externa para una función tan crítica representaba un riesgo para la estabilidad y evolución del proyecto.

Para superar esto, Docker, Inc. desarrolló **libcontainer**, una herramienta propia diseñada para ser independiente de la plataforma y permitir a Docker acceder directamente a los componentes fundamentales del kernel del sistema operativo anfitrión. Desde Docker versión 0.9, libcontainer reemplazó a LXC como driver de ejecución predeterminado.

---

### Eliminación del daemon monolítico de Docker

Con el tiempo, el daemon monolítico de Docker se volvió un problema porque:

1. Dificultaba la innovación.
2. Se volvió más lento.
3. No respondía bien a las necesidades del ecosistema.

Para resolverlo, Docker, Inc. inició un proceso para descomponer el daemon en herramientas especializadas y modulares siguiendo la filosofía Unix de crear pequeños programas que puedan combinarse para formar sistemas más complejos. El resultado fue que todo el código relacionado con la ejecución y el runtime de contenedores fue extraído y refactorizado en componentes más pequeños.

---

### Influencia del Open Container Initiative (OCI)

Paralelamente, el **Open Container Initiative (OCI)** definía estándares para contenerización, principalmente dos especificaciones publicadas en julio de 2017:

* **Image Spec** (especificación de imagen)
* **Container Runtime Spec** (especificación del runtime de contenedores)

Estas especificaciones buscan estabilidad y estandarización, y Docker ha adoptado completamente estas normas desde 2016. Esto llevó a que el daemon Docker ya no contenga código de runtime de contenedores, el cual ahora se implementa en una capa OCI independiente.

Por defecto, Docker utiliza **runc** como runtime de contenedores OCI-compliant, mientras que **containerd** se encarga de presentar las imágenes Docker a runc como bundles compatibles con OCI.

---

### runc: El runtime de bajo nivel

**runc** es la implementación de referencia del runtime OCI. Originado como un CLI ligero que actúa como un wrapper para libcontainer, su único propósito es crear contenedores. Es rápido y minimalista, pero carece de funcionalidades avanzadas que ofrece el motor Docker completo. Puede ser usado directamente para crear contenedores OCI, pero no tiene la riqueza funcional del ecosistema Docker.

---

### containerd: El supervisor de ciclo de vida

**containerd** es una herramienta modular diseñada para gestionar operaciones del ciclo de vida de contenedores como iniciar, detener, pausar o eliminar. Funciona como un daemon en Linux y Windows y, desde Docker 1.11, se usa en la arquitectura Docker.

Inicialmente simple, containerd ha incorporado funcionalidades adicionales (gestión de imágenes, volúmenes, redes) para facilitar su integración en proyectos externos como Kubernetes. Estas funcionalidades son modulares y opcionales.

containerd fue desarrollado por Docker, Inc. y donado a la Cloud Native Computing Foundation (CNCF), alcanzando el estado de proyecto graduado y listo para producción.

---

### Ejemplo de creación de un contenedor

El comando típico para iniciar un contenedor es:

```bash
docker run --name ctr1 -it alpine:latest sh
```

Este comando es transformado por el cliente Docker en una llamada API que envía al daemon Docker a través del socket local (`/var/run/docker.sock` en Linux o `\pipe\docker_engine` en Windows).

El daemon, sin código de creación de contenedores, delega esta tarea a containerd mediante una API CRUD basada en gRPC. containerd no crea el contenedor directamente, sino que convierte la imagen Docker en un bundle OCI y solicita a runc que cree el contenedor.

runc interactúa con el kernel del sistema operativo para ensamblar los elementos necesarios (namespaces, cgroups) y ejecuta el proceso contenedor. Luego, runc termina su ejecución.

---

### Beneficio principal: contenedores "daemonless"

Al separar la lógica del runtime del daemon, el contenedor puede seguir funcionando independientemente del estado del daemon Docker, lo que permite actualizaciones y mantenimiento del daemon sin afectar contenedores en ejecución.

Antes, reiniciar o detener el daemon terminaba todos los contenedores en el host, lo cual era problemático en producción. Ahora, este problema está resuelto.

---

### ¿Qué es el shim?

El **shim** es un componente esencial para la arquitectura daemonless. containerd crea un proceso runc para cada contenedor, pero cuando runc finaliza tras crear el contenedor, el proceso shim asume el rol de padre del contenedor.

El shim mantiene abiertos los flujos STDIN y STDOUT para que la interacción con el contenedor no se interrumpa durante reinicios del daemon, y también comunica el estado de salida del contenedor al daemon.

---

### Implementación en Linux

En Linux, los componentes descritos existen como binarios independientes:

* `/usr/bin/dockerd`: daemon Docker
* `/usr/bin/containerd`: gestor de ciclo de vida de contenedores
* `/usr/bin/containerd-shim-runc-v2`: shim para runc
* `/usr/bin/runc`: runtime OCI de bajo nivel

Se pueden observar estos procesos en ejecución con comandos como `ps` cuando hay contenedores activos.

---

### ¿Qué funciones quedan en el daemon?

Con la modularización, el daemon mantiene funciones como:

* Gestión de imágenes (en proceso de ser transferida a containerd)
* Implementación de la API Docker
* Autenticación y seguridad
* Gestión de redes y volúmenes

El daemon continúa evolucionando para convertirse en un componente más especializado y ligero.

---




### Concepto y estructura de una imagen

Una imagen en Docker funciona como un archivo manifest que contiene una lista de capas (layers) y metadatos. La aplicación y sus dependencias residen dentro de estas capas, que son totalmente independientes y no tienen conciencia de formar parte de un conjunto mayor. Cada imagen se identifica mediante un ID criptográfico (crypto ID) que es un hash del archivo manifest, mientras que cada capa tiene un crypto ID basado en el hash del contenido de dicha capa.

Esto implica que cualquier cambio en la imagen o en cualquiera de sus capas provoca una modificación en sus respectivos hashes. Por tanto, las imágenes y capas son inmutables (immutable), lo que facilita detectar cualquier alteración.

### Complicaciones con compresión y hashes

Cuando se suben (push) o descargan (pull) imágenes, las capas se comprimen para ahorrar ancho de banda y espacio en el registro (registry). Sin embargo, la compresión altera el contenido, haciendo que los hashes de contenido originales ya no coincidan tras estas operaciones.

Esto genera un problema para la verificación de integridad, como la que realiza Docker Hub, que valida cada capa subida con un hash para asegurarse de que no ha sido manipulada. Debido a la compresión, esta verificación fallaría.

La solución es el uso del "distribution hash", que es el hash calculado sobre la versión comprimida de la capa. Este hash de distribución se incluye con cada capa enviada y recibida, garantizando que la capa no fue alterada durante la transferencia.

### Imágenes multi-arquitectura (multi-architecture images)

Docker inicialmente es muy simple, pero al crecer la tecnología tuvo que adaptarse para soportar múltiples plataformas y arquitecturas (Windows, Linux, ARM, x64, PowerPC, s390x, etc.). Esto complicaba el proceso para los usuarios, quienes debían asegurarse de descargar la imagen correcta para su plataforma y arquitectura específicas.

**Definiciones clave:**

* *Arquitectura* (architecture): se refiere al tipo de CPU, como x64, ARM.
* *Plataforma* (platform): se refiere al sistema operativo (Linux, Windows) o a la combinación OS + arquitectura.

La solución fue crear imágenes multi-arquitectura: un solo tag de imagen (como `golang:latest`) puede contener versiones para diferentes combinaciones de plataforma y arquitectura. Así, al ejecutar un simple comando `docker pull golang:latest`, Docker automáticamente obtiene la imagen adecuada para la plataforma y arquitectura del host.

### Cómo funcionan las imágenes multi-arquitectura

El API del registro (Registry API) utiliza dos constructos principales:

* **Manifest lists**: una lista que indica las arquitecturas soportadas por un tag de imagen.
* **Manifests**: cada uno corresponde a una arquitectura específica e incluye la configuración de la imagen y las capas correspondientes.

Por ejemplo, para el tag `golang:latest`, el manifest list contiene entradas para Linux en x64, Linux en PowerPC, Windows en x64, Linux en ARM, etc. Cuando un cliente Docker (por ejemplo, un Raspberry Pi con Linux ARM) realiza un pull, primero obtiene el manifest list, busca la entrada correspondiente a su plataforma/arquitectura, luego descarga el manifest y, finalmente, las capas asociadas.

### Ejemplos prácticos

* En un sistema Linux ARM64:

  ```bash
  docker run --rm golang go version
  ```

  Salida:
  `go version go1.20.4 linux/arm64`

* En un sistema Windows x64:

  ```powershell
  docker run --rm golang go version
  ```

  Salida:
  `go version go1.20.4 windows/amd64`

Ambos comandos son idénticos, pero Docker gestiona automáticamente la selección de la imagen correcta.

### Inspección de manifest lists

El comando `docker manifest inspect` permite examinar el manifest list de cualquier imagen en Docker Hub. Por ejemplo:

```bash
docker manifest inspect golang | grep 'architecture\|os'
```

muestra las arquitecturas y sistemas operativos soportados, incluyendo versiones específicas de Windows.

### Creación de imágenes multi-arquitectura propias

Se pueden construir imágenes para diferentes plataformas y arquitecturas usando `docker buildx`. Por ejemplo, para crear una imagen para ARMv7 basada en un repositorio:

```bash
docker buildx build --platform linux/arm/v7 -t myimage:arm-v7 .
```

El comando puede ejecutarse en una máquina con arquitectura distinta, no es necesario usar un nodo ARMv7.

### Eliminación de imágenes (Deleting Images)

Para eliminar imágenes locales se usa el comando:

```bash
docker rmi <image_id>
```

Esto elimina la imagen y sus capas del host local. Sin embargo, capas compartidas entre varias imágenes no se eliminan hasta que todas las imágenes que las referencian sean eliminadas.

No es posible eliminar una imagen si está siendo usada por contenedores activos o detenidos, primero se deben parar y eliminar esos contenedores.

Ejemplo para eliminar varias imágenes:

```bash
docker rmi image_id1 image_id2
```

Un atajo útil para eliminar todas las imágenes es combinar:

```bash
docker rmi $(docker images -q) -f
```

Este comando obtiene todos los IDs de imágenes y las elimina forzosamente. En Windows funciona en PowerShell, no en CMD.

### Comandos clave para trabajar con imágenes

* `docker pull`: descarga imágenes de registros remotos (por defecto Docker Hub). Ejemplo:

  ```bash
  docker pull alpine:latest
  ```
* `docker images`: lista imágenes locales; con `--digests` muestra sus digests SHA256.
* `docker inspect`: muestra detalles completos de una imagen, capas y metadatos.
* `docker manifest inspect`: inspecciona manifest lists en registros remotos.
* `docker buildx`: extensión CLI para construir imágenes multi-arquitectura.
* `docker rmi`: elimina imágenes locales, pero no permite eliminar imágenes asociadas a contenedores activos o detenidos.



---


### Políticas de reinicio de contenedores en Docker

El capítulo comienza explicando la política de reinicio **--restart always**, la más simple y estricta. Esta política hace que Docker reinicie automáticamente un contenedor si falla o se detiene inesperadamente, a menos que el contenedor haya sido detenido explícitamente con `docker stop`. Por ejemplo, si se inicia un contenedor interactivo con esta política y se ejecuta un shell (`sh`), al salir del shell (comando `exit`), el proceso principal (PID 1) del contenedor termina, lo que detiene el contenedor. Sin embargo, Docker reinicia automáticamente el mismo contenedor —no crea uno nuevo— y el tiempo de actividad mostrado por `docker ps` será menor que el tiempo desde su creación.

Otra característica importante de la política **always** es que, aunque el contenedor haya sido detenido con `docker stop`, si se reinicia el daemon de Docker, el contenedor se reiniciará automáticamente.

En contraste, la política **--restart unless-stopped** no reinicia contenedores que hayan sido detenidos manualmente (`docker stop`) cuando se reinicia el daemon de Docker. Es decir, si un contenedor con esta política está detenido, al reiniciar Docker no se levantará automáticamente.

Se ilustra esto con un ejemplo práctico:

1. Crear dos contenedores:

   * Uno con política `--restart always`
   * Otro con política `--restart unless-stopped`
2. Parar ambos con `docker stop`.
3. Reiniciar el daemon de Docker (`systemctl restart docker` en Linux con systemd).
4. Observar que el contenedor con `--restart always` se reinicia automáticamente, mientras que el de `--restart unless-stopped` permanece detenido.

La política **on-failure** reinicia un contenedor solo si su proceso termina con un código de salida distinto de cero (fallo), y también reinicia contenedores detenidos cuando se reinicia el daemon.

Para entornos Docker Compose o Docker Stacks, la política de reinicio se define dentro del objeto `restart_policy` de un servicio, con valores posibles: `always`, `unless-stopped`, o `on-failure`.

---

### Ejemplo de servidor web en Linux con Docker

El capítulo continúa mostrando cómo iniciar un contenedor que ejecuta una aplicación web basada en Node.js, escuchando en el puerto 8080 dentro del contenedor. Se usa el comando:

```bash
docker run -d --name webserver -p 80:8080 nigelpoulton/ddd-book:web0.1
```

Aquí:

* `-d` ejecuta el contenedor en modo "detached" o en segundo plano.
* `--name webserver` nombra el contenedor.
* `-p 80:8080` mapea el puerto 80 del host al 8080 del contenedor, permitiendo acceso externo a la aplicación web.
* Se usa la imagen `nigelpoulton/ddd-book:web0.1`, que contiene un servidor Node.js.

Al listar los contenedores con `docker ps`, se muestra el mapeo de puertos y el estado de ejecución.

Desde un navegador, se puede acceder a la aplicación apuntando a `localhost:80` (o la IP/DNS del host Docker).

El capítulo destaca que el contenedor funciona sin que el usuario especifique explícitamente qué aplicación ejecutar, gracias a que la imagen contiene una instrucción predeterminada (`Entrypoint`) que indica el comando por defecto (`node ./app.js`).

Este comportamiento se confirma con `docker inspect` sobre la imagen, mostrando que el contenedor ejecuta el comando Node.js automáticamente al iniciarse.

---

### Limpieza rápida de contenedores

Para eliminar rápidamente todos los contenedores de un host Docker, se puede usar:

```bash
docker rm $(docker ps -aq) -f
```

* `docker ps -aq` lista todos los IDs de contenedores, tanto activos como detenidos.
* `docker rm` con `-f` fuerza la eliminación incluso de contenedores en ejecución, destruyéndolos sin oportunidad de limpieza.

Se advierte que esta operación no debe realizarse en sistemas de producción o con contenedores importantes, ya que borra todo sin advertencia.

---

### Comandos esenciales para manejar contenedores

El capítulo resume los comandos más importantes para gestionar contenedores Docker:

* **docker run**: crea y arranca un contenedor basado en una imagen, ejecutando el comando especificado. Por ejemplo, `docker run -it ubuntu /bin/bash` inicia un contenedor Ubuntu con una shell interactiva.
* **Ctrl-P Q**: secuencia para desacoplar (detach) la terminal de un contenedor sin detenerlo.
* **docker ps**: lista contenedores en ejecución; `docker ps -a` incluye también los detenidos.
* **docker exec**: ejecuta un nuevo proceso dentro de un contenedor activo, útil para abrir un shell adicional, p.ej. `docker exec -it <container> bash`.
* **docker stop**: detiene un contenedor enviando señales SIGTERM y luego SIGKILL si es necesario.
* **docker start**: reinicia un contenedor detenido.
* **docker rm**: elimina un contenedor detenido; se recomienda parar el contenedor antes de borrarlo.
* **docker inspect**: muestra información detallada sobre la configuración y estado de un contenedor.

---



### Construcción de imágenes con múltiples etapas (multi-stage builds)

El capítulo inicia mostrando un Dockerfile que define varias etapas de construcción para una aplicación en Go. Se utiliza la imagen base `golang:1.20-alpine` para crear dos binarios, uno para el cliente (`client`) y otro para el servidor (`server`), cada uno en etapas separadas llamadas `build-client` y `build-server`. Luego, en las etapas finales `prod-client` y `prod-server`, que usan la imagen base mínima `scratch`, se copian los binarios desde las etapas de construcción para generar imágenes finales optimizadas y de pequeño tamaño.

Esto permite que la imagen final contenga solo el binario compilado y no todo el entorno de compilación, reduciendo significativamente el tamaño de la imagen. Se ejemplifica el uso del flag `--target` de `docker build` para construir imágenes específicas de estas etapas nombradas.

Los tamaños de las imágenes muestran que las imágenes finales del cliente y servidor pesan aproximadamente la mitad de la imagen combinada, dado que esta última incluye ambos binarios y las dependencias del build.

---

### Construcción multiplataforma (multi-platform builds)

El capítulo explica cómo, usando `docker buildx`, es posible construir imágenes para múltiples arquitecturas en un solo comando, crucial para soportar diferentes entornos como ARM (M1 Mac) y AMD64 (x86\_64).

* Se verifica la instalación de `buildx` con `docker buildx version`.
* Se crea un builder con el driver `docker-container`.
* Se usa un ejemplo para construir y subir imágenes a Docker Hub para tres plataformas: `linux/amd64`, `linux/arm64` y `linux/arm/v7`.
* Se destacan las ventajas de construir multi-plataforma para que los usuarios puedan descargar la imagen correcta según su hardware, sin importar si es ARM o AMD.

Las instrucciones del Dockerfile se ejecutan para cada plataforma y las capas resultantes se empujan a Docker Hub con soporte para manifest lists, permitiendo que Docker seleccione automáticamente la imagen correcta.

---

### Mejores prácticas para Dockerfiles y construcción de imágenes

**Uso eficiente de la caché de construcción**

* Docker construye imágenes en capas, una por cada instrucción del Dockerfile.
* Si una instrucción ya fue ejecutada con el mismo contexto, Docker reutiliza la capa de la caché (cache hit).
* Cuando una instrucción cambia (cache miss), se invalidan todas las capas siguientes.
* Por ello, se recomienda ordenar las instrucciones en el Dockerfile de modo que las que cambian con más frecuencia queden hacia el final, maximizando la reutilización de la caché.

Ejemplo típico:

* `FROM alpine`
* `RUN apk add --update nodejs nodejs-npm` (puede ser cacheado si no cambia)
* `COPY . /src` (suele invalidar la caché si el código cambia)
* `RUN npm install`
* `EXPOSE 8080`
* `ENTRYPOINT ["node", "./app.js"]`

El COPY se basa en sumas de verificación (checksums) para detectar cambios en el contenido, no solo en la instrucción.

Se puede forzar ignorar la caché con el flag `--no-cache` en el comando `docker build`.

---

### Imagenes “squashed” (comprimidas en una sola capa)

* La opción `--squash` crea una imagen con todas las capas combinadas en una sola, reduciendo el tamaño.
* Sin embargo, estas imágenes no pueden compartir capas con otras imágenes, lo que puede aumentar el uso total de disco.
* Además, en pushes a Docker Hub, deben enviarse todos los datos, mientras que las imágenes no comprimidas solo envían las capas únicas.
* Por estas razones, el squash no es una práctica recomendada universalmente.

---

### Uso del flag `no-install-recommends` con apt-get

* En imágenes basadas en Debian/Ubuntu, se recomienda usar `apt-get install --no-install-recommends`.
* Esto evita instalar paquetes recomendados y sugeridos, reduciendo la cantidad de dependencias innecesarias y el tamaño de la imagen.

---

### Comandos básicos y explicaciones de Dockerfiles

* `docker build`: construye una imagen leyendo un Dockerfile.

  * `-t`: etiqueta la imagen con un nombre y etiqueta.
  * `-f`: especifica la ruta y nombre del Dockerfile.
* `FROM`: define la imagen base para la construcción o etapa.
* `RUN`: ejecuta comandos dentro de la imagen durante la construcción, generando una capa nueva.
* `COPY`: copia archivos/directorios al sistema de archivos de la imagen, creando una nueva capa.
* `EXPOSE`: documenta el puerto de red que la aplicación usa.
* `ENTRYPOINT`: define el comando principal que se ejecutará cuando se inicie el contenedor.
* Otros comandos comunes: `LABEL`, `ENV`, `ONBUILD`, `HEALTHCHECK`, `CMD`.

---


## Limpieza de recursos con `docker-compose down`

El comando:

```bash
docker-compose down --volumes --rmi all
```

detiene y elimina todos los contenedores de la aplicación multi-contenedor, elimina las redes asociadas, elimina los volúmenes y elimina también las imágenes (flag `--rmi all`). Este es un paso importante para limpiar todos los recursos creados durante el despliegue de la aplicación.

---

## Uso de volúmenes para insertar datos persistentes

Cuando se despliega la aplicación con:

```bash
docker compose up --detach
```

Docker Compose verifica si existe un volumen llamado `counter-vol`. Si no existe, lo crea automáticamente. Este volumen se monta en el contenedor `web-fe` en la ruta `/app`, que es donde la aplicación está instalada y ejecutándose (según el Dockerfile).

El volumen puede verse listando con:

```bash
docker volume ls
```

Y obtener detalles con:

```bash
docker volume inspect multi-container_counter-vol
```

Es importante destacar que Docker Compose crea volúmenes y redes antes de desplegar los servicios, porque estos son componentes de infraestructura necesarios para los contenedores.

---

## Volúmenes montados y su impacto en la ejecución

El montaje del volumen en `/app` permite que el código de la aplicación se ejecute directamente desde el volumen. Esto habilita la posibilidad de modificar archivos fuera del contenedor y que los cambios se reflejen inmediatamente en la aplicación en ejecución.

### Ejemplo práctico para ver cambios en volumen

1. Se modifica el archivo `app/templates/index.html` en el contexto local del proyecto.
2. Se copia el archivo actualizado al volumen en el sistema de archivos del host Docker.
3. Al actualizar la página web, se reflejan los cambios en la app.

**Nota:** Esta práctica no funciona en Docker Desktop para Mac o Windows debido a que Docker Desktop ejecuta Docker dentro de una VM ligera donde los volúmenes están encapsulados.

Para encontrar el path del volumen en el host:

```bash
docker inspect multi-container_counter-vol | grep Mountpoint
```

Ejemplo de copiar el archivo actualizado al volumen (se puede requerir `sudo`):

```bash
cp ./counter-app/app.py /var/lib/docker/volumes/multi-container_counter-vol/_data/app/templates/index.html
```

Luego, al acceder a la aplicación (por ejemplo, en `http://<IP_DockerHost>:5001`), se verá el contenido actualizado.

---

## Gestión básica de aplicaciones con Docker Compose: comandos clave

* **`docker compose up`**: despliega la aplicación definida en el archivo Compose (por defecto `compose.yaml`), creando imágenes, contenedores, redes y volúmenes. El flag `--detach` inicia los contenedores en segundo plano.

* **`docker compose stop`**: detiene todos los contenedores sin eliminarlos, permitiendo reinicios rápidos con `docker compose restart`.

* **`docker compose rm`**: elimina contenedores y redes de una app detenida, pero no elimina volúmenes ni imágenes por defecto.

* **`docker compose restart`**: reinicia una app detenida. Cambios realizados en el archivo Compose mientras la app está detenida no se aplican hasta un nuevo despliegue (`up`).

* **`docker compose ps`**: muestra una lista de contenedores de la app, su estado, comandos y puertos expuestos.

* **`docker compose down`**: detiene y elimina contenedores y redes, pero no elimina volúmenes ni imágenes.

---



# Capítulo 10: Docker Swarm

### Resolución de problemas (Troubleshooting)

Para visualizar los logs de los servicios en Swarm se utiliza el comando `docker service logs <nombre-servicio>`. Sin embargo, no todos los drivers de logging (log drivers) soportan este comando. Por defecto, los nodos Docker configuran los servicios para usar el driver de logs `json-file`, aunque existen otros como:

* `awslogs`
* `gelf`
* `gcplogs`
* `journald` (funciona solo en hosts Linux con systemd)
* `splunk`
* `syslog`

Los drivers `json-file` y `journald` son los más sencillos de configurar y funcionan con `docker service logs`. Si se usan drivers de terceros, se deben revisar los logs con las herramientas nativas de la plataforma de logging.

La configuración del driver de logs en el host Docker se puede definir en el archivo `daemon.json` (por defecto ubicado en `/etc/docker/daemon.json`), aunque puede no existir hasta que se cree manualmente. Un ejemplo para usar `syslog`:

```json
{
  "log-driver": "syslog"
}
```

Se puede forzar que un servicio use un driver distinto al predeterminado al crear el servicio con `docker service create --log-driver` y `--log-opts`, los cuales sobrescriben la configuración del `daemon.json`.

Los servicios esperan que las aplicaciones se ejecuten como PID 1, enviando logs a STDOUT y errores a STDERR, que son capturados por el driver de logging y enviados a la ubicación configurada.

Ejemplo de salida de `docker service logs svc1` muestra logs de todas las réplicas de un servicio, identificando cada línea con nombre de réplica, ID y host, permitiendo diagnosticar fallos, por ejemplo cuando algunas réplicas fallan al intentar conectar con otro servicio que aún está iniciándose.

Opciones útiles del comando:

* `--follow` para seguir logs en tiempo real.
* `--tail` para mostrar solo las últimas líneas.
* `--details` para obtener información adicional.

---

### Respaldo (Backup) y recuperación de un Swarm

El respaldo del Swarm consiste en guardar la configuración y estado del plano de control (control plane), útil en casos extremos de fallos o corrupción. Aunque el plano de control es replicado y altamente disponible (HA), el respaldo es necesario ante operaciones destructivas propagadas a todos los nodos, como la eliminación maliciosa de Secrets, donde HA propaga rápidamente la pérdida.

Para minimizar riesgos, es recomendable gestionar configuraciones y objetos declarativamente fuera del Swarm, por ejemplo en repositorios de control de versiones, para permitir redeploys en caso de desastre.

#### Cómo respaldar un Swarm

* La configuración del Swarm se almacena en `/var/lib/docker/swarm` en cada nodo manager.
* Esta carpeta contiene el log de Raft, redes overlay, Secrets, Configs, Servicios, etc.
* Dado que los datos se replican en todos los managers, se puede hacer backup desde cualquiera, pero se recomienda hacerlo desde un manager no líder para evitar elecciones de líder (leader election) al detener Docker.
* Detener el demonio Docker (`service docker stop`) en el manager elegido.
* Realizar la copia (ejemplo con `tar -czvf swarm.bkp /var/lib/docker/swarm/`).
* Verificar que el archivo de backup exista.
* Reiniciar el demonio Docker (`service docker restart`).
* Si el Swarm está bloqueado, desbloquear con `docker swarm unlock` usando la clave correspondiente.

Es aconsejable realizar el backup en horarios de baja actividad para minimizar riesgos.

#### Cómo recuperar un Swarm desde backup

Solo debe realizarse en caso de corrupción o pérdida irrecuperable.

Requisitos para la recuperación:

1. Restaurar en un nodo con la misma versión de Docker que el backup.
2. Restaurar en un nodo con la misma IP que el original.

Pasos para restaurar:

1. Detener Docker en el nodo.
2. Eliminar la carpeta `/var/lib/docker/swarm`.
3. Extraer el backup (ejemplo: `tar -zxvf swarm.bkp -C /`).
4. Verificar que los archivos se hayan restaurado.
5. Iniciar Docker (`service docker start`).
6. Desbloquear el Swarm si está bloqueado (`docker swarm unlock`).
7. Inicializar un nuevo Swarm forzando un nuevo cluster con `docker swarm init --force-new-cluster --advertise-addr <IP>:2377 --listen-addr <IP>:2377`.
8. Verificar que las redes overlay (por ejemplo, `unimatrix01`) se hayan recuperado (`docker network ls`).
9. Añadir nuevos managers y workers según sea necesario y realizar backups frescos.

Se recomienda probar este procedimiento de recuperación regularmente.

---

### Comandos esenciales de Docker Swarm

* `docker swarm init`: crea un nuevo Swarm, el nodo actual se vuelve manager y entra en modo Swarm.
* `docker swarm join-token`: muestra comandos y tokens para unir managers o workers al Swarm.
* `docker node ls`: lista todos los nodos del Swarm, indicando roles y líder.
* `docker service create`: crea un nuevo servicio.
* `docker service ls`: lista servicios en ejecución con estado y réplicas.
* `docker service ps <servicio>`: muestra información detallada de réplicas.
* `docker service inspect`: muestra detalles del servicio, con opción `--pretty` para formato legible.
* `docker service scale`: cambia el número de réplicas.
* `docker service update`: actualiza propiedades de un servicio en ejecución.
* `docker service logs`: visualiza logs del servicio.
* `docker service rm`: elimina un servicio (elimina todas sus réplicas sin confirmación).

---



