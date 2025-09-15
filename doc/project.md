
## 🚀 Instalando Docker en Debian (VM)

### ✅ Paso 1: Actualiza tu sistema

```bash
sudo apt update
sudo apt upgrade -y
```

---

### ✅ Paso 2: Instala paquetes necesarios

```bash
sudo apt install ca-certificates curl gnupg lsb-release -y
```

---

### ✅ Paso 3: Crea el directorio para la clave GPG

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```
- Crea el directorio /etc/apt/keyrings con permisos seguros (0755).

- Este directorio se usa para guardar claves GPG que verifican la autenticidad de los paquetes descargados desde repositorios externos (como el de Docker). Es una práctica moderna y más segura que usar /etc/apt/trusted.gpg.
- 
---

### ✅ Paso 4: Descarga la clave GPG de Docker

Usamos `wget` para evitar errores con `curl`:

```bash
wget https://download.docker.com/linux/ubuntu/gpg -O docker.gpg
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg docker.gpg
```
- Descarga la clave pública de Docker desde su servidor oficial.

- gpg --dearmor : Convierte la clave desde formato ASCII (texto plano) a formato binario (.gpg) que APT puede usar.

 - Cuando agregas el repositorio de Docker, APT necesita verificar que los paquetes provienen realmente de Docker Inc. Esta clave permite esa verificación.

---

### ✅ Paso 5: Agrega el repositorio oficial de Docker

Como estás en Debian (y Trixie aún no está soportado oficialmente), usamos el repositorio de **Bookworm**:

```bash
echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  bookworm stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

### ✅ Paso 6: Instala Docker

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

---

### ✅ Paso 7: Verifica que Docker funciona

```bash
sudo docker run hello-world
```

Si ves el mensaje “Hello from Docker!”, ¡todo está funcionando correctamente!


---

