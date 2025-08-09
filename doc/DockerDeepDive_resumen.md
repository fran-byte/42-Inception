
### 1: Contenedores desde 30,000 pies de altura

¡Los contenedores han conquistado el mundo!
En este capítulo veremos por qué tenemos contenedores, qué hacen por nosotros y dónde podemos usarlos.

---

### Los malos viejos tiempos

Las aplicaciones son el corazón de las empresas. Si las aplicaciones fallan, las empresas fallan.
A veces incluso quiebran. ¡Estas afirmaciones son cada vez más ciertas!

La mayoría de las aplicaciones se ejecutan en servidores. En el pasado, solo podíamos ejecutar **una aplicación por servidor**. El mundo de sistemas abiertos como Windows y Linux simplemente no tenía las tecnologías para ejecutar de forma segura múltiples aplicaciones en el mismo servidor.

Como resultado, la historia era más o menos así: cada vez que la empresa necesitaba una nueva aplicación, el departamento de TI compraba un nuevo servidor.
La mayoría de las veces, nadie sabía los requisitos de rendimiento de la nueva aplicación, lo que obligaba al departamento de TI a adivinar el modelo y tamaño del servidor que debía comprar.

La única opción de TI era comprar **servidores grandes y rápidos**, que costaban mucho dinero.
Después de todo, lo último que alguien quería, incluido el negocio, era servidores con poca potencia incapaces de procesar transacciones y potencialmente perder clientes e ingresos. Así que TI compraba grande.
Esto daba como resultado **servidores sobredimensionados** operando al **5–10% de su capacidad**, un desperdicio trágico de capital de la empresa y de recursos medioambientales.

---

### ¡Hola VMware!

En medio de todo esto, **VMware, Inc.** dio al mundo un regalo: la **máquina virtual (VM)**.
Casi de la noche a la mañana, el mundo cambió para mejor. Finalmente teníamos una tecnología que permitía ejecutar **múltiples aplicaciones de negocio de forma segura en un solo servidor**.
¡Cue fuegos artificiales!

Esto fue un cambio radical. El departamento de TI ya no necesitaba adquirir un nuevo servidor sobredimensionado cada vez que el negocio pedía una nueva aplicación.
Muchas veces podían ejecutar nuevas aplicaciones en **servidores existentes con capacidad sobrante**.

De repente, podíamos **aprovechar al máximo los activos corporativos existentes**, sacando mucho más rendimiento por cada dólar invertido.

---

### VMwarts

Pero… ¡siempre hay un “pero”!
Aunque las VMs son geniales, están lejos de ser perfectas.

El hecho de que **cada VM requiera su propio sistema operativo (OS)** es un gran inconveniente.
Cada OS consume CPU, RAM y otros recursos que podrían usarse para ejecutar más aplicaciones. Cada OS necesita parches y monitorización. Y en algunos casos, cada OS requiere una licencia. Todo esto supone **tiempo y recursos desperdiciados**.

El modelo de VM también presenta otros desafíos:

* Son **lentas de arrancar**.
* La **portabilidad** no es ideal: mover cargas de trabajo de VMs entre hipervisores y nubes es más difícil de lo que debería.

---

### ¡Hola contenedores!

Durante mucho tiempo, grandes empresas de escala web como Google usaron tecnologías de contenedores para resolver las carencias del modelo de VM.

En el modelo de contenedores, el contenedor es **aproximadamente análogo a una VM**, pero con una gran diferencia: **no necesita su propio sistema operativo completo**.
Todos los contenedores en un mismo host **comparten el OS del host**. Esto libera grandes cantidades de recursos como CPU, RAM y almacenamiento, reduce costes de licencias y disminuye la carga de mantenimiento del OS.

**Resultado neto:** ahorro en tiempo, recursos y capital.

Además:

* Los contenedores **arrancan rápido**.
* Son **ultraportátiles**: mover cargas de contenedores de tu laptop a la nube, a VMs o a bare metal en tu centro de datos es muy sencillo.

---

### Contenedores Linux

Los contenedores modernos empezaron en el mundo Linux, fruto de un inmenso trabajo de muchas personas y organizaciones a lo largo de los años.
Por ejemplo, **Google LLC** ha contribuido con muchas tecnologías relacionadas con contenedores al **kernel de Linux**. Sin estas y otras aportaciones, no tendríamos los contenedores modernos de hoy.

Algunas tecnologías clave que impulsaron el crecimiento masivo de los contenedores incluyen:

* **Kernel namespaces**
* **Control groups (cgroups)**
* **Capabilities**
* **Docker**

El ecosistema moderno de contenedores está profundamente en deuda con todos los que sentaron sus bases.

---

Pese a todo esto, los contenedores eran complejos y fuera del alcance de la mayoría de organizaciones… hasta que llegó **Docker** y los democratizó.

**Nota:** existen tecnologías de virtualización de sistemas operativos similares a los contenedores que son anteriores a Docker, como:

* **System/360** en mainframes
* **BSD Jails**
* **Solaris Zones**

En este libro nos centraremos en los contenedores modernos popularizados por Docker.

---

### ¡Hola Docker!

Veremos Docker en detalle en el siguiente capítulo, pero por ahora basta con decir que Docker fue la “magia” que hizo que los contenedores Linux fueran usables por cualquier persona.
En pocas palabras, **Docker, Inc. simplificó los contenedores**.

---

### Docker y Windows

Microsoft trabajó mucho para llevar Docker y las tecnologías de contenedores a Windows.
Actualmente, las plataformas Windows de escritorio y servidor soportan:

* **Windows containers**
* **Linux containers**

**Windows containers** ejecutan aplicaciones Windows y requieren un host con kernel de Windows.
Windows 10, Windows 11 y las versiones modernas de Windows Server tienen soporte nativo para Windows containers.

Cualquier host Windows con **WSL 2 (Windows Subsystem for Linux)** puede ejecutar contenedores Linux, lo que hace de Windows 10 y 11 plataformas excelentes para desarrollar y probar contenedores Linux y Windows.

---

A pesar del trabajo de Microsoft, la gran mayoría de contenedores son Linux, ya que:

* Son **más pequeños y rápidos**.
* La mayoría de herramientas está disponible para Linux.

Todos los ejemplos de este libro son con **contenedores Linux**.

---

### Windows containers vs Linux containers

Un contenedor **comparte el kernel del host** en el que se ejecuta:

* Aplicaciones Windows necesitan host con kernel Windows.
* Aplicaciones Linux necesitan host con kernel Linux.

Sin embargo, con **WSL 2** es posible ejecutar contenedores Linux en Windows.

---

### ¿Contenedores Mac?

No existen contenedores Mac como tal.
Pero se pueden ejecutar contenedores Linux en Mac usando **Docker Desktop**, que los ejecuta dentro de una **VM Linux ligera**. Esto es muy popular entre desarrolladores.

---

### ¿Y Kubernetes?

**Kubernetes** es un proyecto open-source de Google que se ha convertido en el **orquestador de facto** de aplicaciones en contenedores.

> “Aplicación en contenedor” = aplicación ejecutada como contenedor.

Kubernetes solía usar Docker como runtime por defecto.
Hoy, gracias a la **Container Runtime Interface (CRI)**, puede usar diferentes runtimes.
La mayoría de clústeres modernos usan **containerd**, que es la parte especializada de Docker encargada de arrancar y detener contenedores.

---



### 2: Docker

Ningún libro o conversación sobre contenedores está completo sin hablar de Docker.
Pero cuando decimos “Docker”, podemos referirnos a cualquiera de lo siguiente:

1. Docker, Inc., la empresa.
2. Docker, la tecnología.

---

### Docker - La versión TL;DR

Docker es un software que se ejecuta en Linux y Windows. Crea, gestiona e incluso puede orquestar contenedores.
El software actualmente se construye a partir de varias herramientas del proyecto de código abierto **Moby**.
Docker, Inc. es la empresa que creó la tecnología y que sigue desarrollando tecnologías y soluciones para que sea más fácil ejecutar en la nube el código que tienes en tu portátil.

Esa es la versión rápida. Vamos a profundizar un poco más.

---

### Docker, Inc.

Docker, Inc. es una empresa tecnológica con sede en San Francisco, fundada por el desarrollador y empresario franco-estadounidense **Solomon Hykes**. Solomon ya no forma parte de la compañía.

*Figura 2.1 Logo de Docker, Inc.*

La empresa comenzó como un proveedor de **plataforma como servicio** (PaaS) llamado **dotCloud**.
Detrás de escena, la plataforma dotCloud estaba construida sobre contenedores Linux.
Para ayudar a crear y gestionar estos contenedores, desarrollaron una herramienta interna que eventualmente apodaron **“Docker”**. Así nació la tecnología Docker.

También es interesante saber que la palabra “Docker” proviene de una expresión británica que significa **estibador** (dock worker): alguien que carga y descarga mercancía de los barcos.

En 2013, eliminaron el lado de PaaS del negocio, rebrandearon la compañía como **Docker, Inc.** y se centraron en llevar Docker y los contenedores al mundo. Han tenido un éxito enorme en este objetivo.

A lo largo de este libro utilizaremos el término **“Docker, Inc.”** cuando nos refiramos a la empresa. En todos los demás casos, “Docker” se referirá a la tecnología.

---

### La tecnología Docker

Cuando la mayoría de la gente habla de Docker, se refiere a la tecnología que ejecuta contenedores.
Sin embargo, hay al menos tres elementos que debemos conocer al hablar de Docker como tecnología:

1. El **runtime** (tiempo de ejecución).
2. El **daemon** (también llamado engine).
3. El **orchestrator** (orquestador).

*Figura 2.2 Arquitectura de Docker.*

---

#### **El runtime**

Opera en el nivel más bajo y es responsable de iniciar y detener contenedores (esto incluye construir todos los elementos del sistema operativo como **namespaces** y **cgroups**).
Docker implementa una arquitectura de runtime por niveles: **runtime de alto nivel** y **runtime de bajo nivel** que trabajan juntos.

* **Runtime de bajo nivel:** llamado **runc**, es la implementación de referencia de la especificación **OCI runtime-spec** de la **Open Containers Initiative (OCI)**. Su función es interactuar con el sistema operativo subyacente e iniciar o detener contenedores. Cada contenedor en un nodo Docker fue creado e iniciado por una instancia de **runc**.

* **Runtime de alto nivel:** llamado **containerd**, gestiona todo el ciclo de vida del contenedor, incluyendo la descarga de imágenes y la gestión de instancias de **runc**. Se pronuncia *container-dee*, es un proyecto graduado de la **CNCF** y es usado por Docker y Kubernetes.

Una instalación típica de Docker tiene un único proceso **containerd** en ejecución permanente, que instruye a **runc** para iniciar o detener contenedores.
**runc** nunca es un proceso de larga duración: termina tan pronto como el contenedor se inicia.

---

#### **El daemon de Docker**

El **Docker daemon** (**dockerd**) se sitúa por encima de **containerd** y realiza tareas de nivel superior, como:

* Exponer la **Docker API**.
* Gestionar imágenes.
* Gestionar volúmenes.
* Gestionar redes.
* Otras funciones de alto nivel.

Una función clave del daemon es proporcionar una interfaz estándar y fácil de usar que abstraiga los niveles inferiores.

---

#### **El orquestador: Docker Swarm**

Docker también tiene soporte nativo para gestionar clústeres de nodos que ejecutan Docker.
Estos clústeres se llaman **swarms** y la tecnología nativa es **Docker Swarm**.
Es fácil de usar y muchas empresas lo usan en producción. Es mucho más sencillo de instalar y gestionar que Kubernetes, pero carece de muchas funciones avanzadas y del ecosistema de Kubernetes.

---

### La Open Container Initiative (OCI)

Anteriormente mencionamos la **Open Containers Initiative (OCI)**.

La OCI es un consejo de gobernanza responsable de estandarizar los componentes fundamentales de bajo nivel de la infraestructura de contenedores. En particular, se enfoca en:

* El formato de imagen (image format).
* El runtime del contenedor (container runtime).

*(Si estos términos no te resultan familiares, los veremos más adelante en el libro).*

---

#### **Un poco de historia según Nigel** 😄 

Desde el primer día, el uso de Docker creció enormemente. Cada vez más personas lo usaban en más formas y para más cosas. Esto inevitablemente llevó a que algunas partes se sintieran frustradas, algo normal y saludable.

En resumen, una empresa llamada **CoreOS** (posteriormente adquirida por Red Hat y luego por IBM) no estaba de acuerdo con la forma en que Docker hacía ciertas cosas. Por ello, crearon un estándar abierto llamado **appc** que definía elementos como el formato de imagen y el runtime del contenedor. También crearon una implementación de esa especificación llamada **rkt** (pronunciado “rocket”).

Esto generó dos estándares en competencia, lo cual amenazaba con fracturar el ecosistema y presentar un dilema a usuarios y clientes. Aunque la competencia suele ser buena, la existencia de estándares en competencia genera confusión y ralentiza la adopción. No es bueno para nadie.

Con esto en mente, todas las partes involucradas actuaron de forma madura y se unieron para formar la **OCI**, un consejo ágil y ligero para gobernar los estándares de contenedores.

---

#### **Especificaciones publicadas por la OCI**

En el momento de la redacción, la OCI ha publicado tres especificaciones:

* **image-spec** (formato de imagen).
* **runtime-spec** (runtime del contenedor).
* **distribution-spec** (especificación de distribución).

Una analogía común es la de las vías de tren:
Estas especificaciones son como acordar un tamaño y propiedades estándar para las vías, dejando que cada uno construya mejores trenes, vagones, sistemas de señalización, estaciones… con la seguridad de que funcionarán en las vías estandarizadas.
Nadie quiere dos estándares diferentes para el tamaño de las vías.

Las especificaciones de la OCI han tenido un gran impacto en la arquitectura y diseño del producto central de Docker. Todas las versiones modernas de Docker y Docker Hub implementan estas especificaciones.
La OCI está organizada bajo el auspicio de la **Linux Foundation**.

---


