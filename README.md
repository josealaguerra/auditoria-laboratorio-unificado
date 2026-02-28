# auditoria-laboratorio-unificado
Pondremos un contenedor con una aplicación en php obsoleto, otro contenedor con un mysql obsoleto y por ultimo un contenedor con kali linux


# Laboratorio de Seguridad - Sistema Ferretería (Legacy)

Este entorno provisiona un laboratorio aislado con PHP 7.4 y MySQL 5.7 para auditoría y pruebas de seguridad usando Kali Linux.

**⚠️ AVISO:** Este setup utiliza software obsoleto de manera intencional. **ÚNICAMENTE** apto para laboratorios locales. No exponer a internet.

## 🚀 Despliegue paso a paso

1. **Preparar el entorno:**
   ```bash
   cp .env.example .env
   chmod +x init-db.sh
   mkdir -p ./data/mysql
   sudo chown -R 999:999 ./data/mysql # 999 suele ser el UID del usuario mysql
   ```

2. **Editar `.env` con tus credenciales:**
   - `PHP_HOST_PORT`: Puerto del host para acceder a la app PHP (ej: 8080)
   - `DB_HOST`: Hostname de la DB (db.ferreteria.local)
   - `DB_USER`: Usuario de la DB
   - `DB_PASSWORD`: Contraseña del usuario
   - `DB_NAME`: Nombre de la base de datos
   - `MYSQL_ROOT_PASSWORD`: Contraseña del root de MySQL

3. **Desplegar los servicios:**
   ```bash
   docker-compose up -d --build
   ```

4. **Verificar el estado:**
   ```bash
   docker-compose ps
   ```
   Deberías ver los 3 servicios en estado "healthy" o "up".

## 🔧 Configuración adicional para herramientas GUI

- **Burp Suite (burp-suite):** Para acceder a la interfaz gráfica, instala [VcXsrv](https://sourceforge.net/projects/vcxsrv/) en tu máquina local. Configura VcXsrv para permitir conexiones desde cualquier host. En el archivo `docker-compose.yml`, la variable `DISPLAY` está configurada como `host.docker.internal:0.0`, pero si no funciona, reemplázala con la IP de tu laptop local (ej: `DISPLAY=192.168.1.100:0.0`). Asegúrate de que VcXsrv esté ejecutándose antes de iniciar el contenedor.

## 📋 Servicios incluidos

- **php-app:** Aplicación web en PHP 7.4 obsoleto, simulando un sistema de ferretería vulnerable para pruebas de seguridad.
- **db:** Base de datos MySQL 5.7 obsoleta, almacenando datos del sistema de ferretería.
- **kali:** Contenedor con Kali Linux, equipado con herramientas de pentesting para auditorías de seguridad.
- **windows-xp:** Máquina virtual Windows XP como objetivo vulnerable, para simular ataques a sistemas legacy.
- **nessus:** Escáner de vulnerabilidades Nessus, para identificar debilidades en la red y aplicaciones.
- **openvas:** Escáner de vulnerabilidades OpenVAS (fork de Nessus), alternativo para detección de vulnerabilidades.
- **zap:** OWASP ZAP, proxy para interceptar y manipular tráfico web durante pruebas de seguridad.
- **burp:** Burp Suite, herramienta para interceptar, analizar y manipular tráfico HTTP/S en aplicaciones web.

## ✅ Validación

1. **Conexión PHP → MySQL:**
   ```bash
   curl http://localhost:8080/test-db.php
   ```
   Debería mostrar "Conexión exitosa a la Base de Datos legacy".

2. **Resolución de hostnames:**
   ```bash
   docker exec kali-tools ping db.ferreteria.local
   ```

3. **Persistencia de datos:**
   - Detén y elimina el contenedor MySQL: `docker-compose stop db && docker-compose rm db`
   - Verifica que `./data/mysql` contenga archivos.

4. **Acceso a Kali:**
   ```bash
   docker exec -it kali-tools bash
   # Dentro del contenedor, prueba: mysql -h db.ferreteria.local -u ferreteria_usr -p
   ```

## 🔧 Solución de problemas comunes

- **Error en construcción de imágenes:** Verifica que Docker tenga acceso a internet y que las imágenes base estén disponibles.
- **Fallo en healthcheck de DB:** Espera a que el init-db.sh termine (puede tomar tiempo en el primer inicio).
- **No se resuelven hostnames:** Asegúrate de que la red `ferreteria-lab-net` esté creada correctamente.

## 📦 Archivos incluidos

- `docker-compose.yml`: Definición de servicios
- `php/Dockerfile`: Personalización para PHP 7.4 con extensiones
- `kali/Dockerfile`: Configuración de Kali con herramientas
- `init-db.sh`: Script para inicializar la base de datos
- `.env.example`: Ejemplo de variables de entorno