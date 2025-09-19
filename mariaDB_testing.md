
## ✅ Testeos rápidos para MariaDB

### 🔹 1. Entrar al contenedor

```bash
docker exec -it mariadb bash
```

---

### 🔹 2. Acceder al cliente MariaDB

```bash
mysql -u frromero -p
```

(Usa la contraseña que definiste en `.env`, por ejemplo: `frromero_pass`)

---

### 🔹 3. Verificar base de datos y usuario

```sql
SHOW DATABASES;
SELECT user, host FROM mysql.user;
```

---

### 🔹 4. Crear algo de prueba

```sql
CREATE DATABASE testdb;
CREATE USER 'testuser'@'%' IDENTIFIED BY 'testpass';
GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'%';
SHOW GRANTS FOR 'testuser'@'%';
```

---

### 🔹 5. Salir

```sql
exit
```

---
