# ROL Y CONTEXTO
Actúa como un Ingeniero DevOps Senior especializado en contenedores Docker y arquitecturas legacy. 
Estoy trabajando en un entorno de **laboratorio aislado para pruebas de migración y análisis de seguridad** 
de un sistema heredado de ferretería. NO es para producción.

# OBJETIVO PRINCIPAL
Diseñar una arquitectura Docker segura y reproducible con 3 servicios interconectados:
1. Aplicación PHP 7.4 (legacy)
2. Base de datos MySQL 5.7 (legacy) 
3. Contenedor Kali Linux para pruebas de integración/seguridad

# REQUISITOS TÉCNICOS DETALLADOS

## 🐘 Servicio 1: PHP 7.4 + Aplicación
- Imagen base: `php:7.4-apache` (especificar tag exacto)
- Clonar y desplegar: https://github.com/andrespaucar/sistemaferreteria/
- Configurar Apache para servir desde `/var/www/html`
- Instalar extensiones requeridas: `mysqli`, `pdo_mysql`, `gd`, `mbstring`
- Exponer puerto interno 80 → mapear a puerto host configurable (ej: 8080)
- Variable de entorno: `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`

## 🐬 Servicio 2: MySQL 5.7 + Persistencia
- Imagen base: `mysql:5.7` (tag específico, ej: 5.7.44)
- Inicializar con: https://github.com/andrespaucar/sistemaferreteria/blob/master/db.sql
- Persistencia: Volumen bind-mount a `./data/mysql` en el host
  - Especificar permisos: `chmod 750` y usuario `mysql:mysql`
- Variables de entorno obligatorias: 
  - `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
- Exponer puerto 3306 solo a la red interna (NO al host)

## 🛡️ Servicio 3: Kali Linux
- Imagen base: `kalilinux/kali-rolling`
- Configurar para acceso SSH (puerto 22) y herramientas de red básicas
- Incluir: `nmap`, `hydra`, `aircrack-ng`, `sqlmap`, `metasploit-framework`, `wireshark`, `autopsy`, `sleuthkit`, `john`, `hashcat`, `net-tools`, `curl`, `wget`, `netcat-traditional`, `default-mysql-client`, `git`, `openssh-server`, `iputils-ping`
- NO exponer puertos al host por defecto (solo acceso interno)

## 🌐 Networking y Comunicaciones
- Crear red Docker personalizada: `ferreteria-lab-net` (driver: bridge)
- Asignar IPs estáticas dentro de la red (ej: 172.20.0.10, .11, .12)
- Configurar hostnames resolvibles:
  - `php-app.ferreteria.local` → PHP
  - `db.ferreteria.local` → MySQL  
  - `kali.ferreteria.local` → Kali
- Verificar que los contenedores se resuelvan por hostname (DNS interno de Docker)

## 📦 Orquestación y Entrega
- Usar `docker-compose.yml` (versión 3.8+) para definir los 3 servicios
- Incluir `.env` example con variables sensibles (NUNCA hardcodear credenciales)
- Proporcionar `Dockerfile` personalizado solo si es necesario (ej: PHP con extensiones)
- Incluir script `init-db.sh` para importar `db.sql` automáticamente al primer inicio

## 🔐 Seguridad y Buenas Prácticas (entorno lab)
- Documentar explícitamente: "Este setup usa software obsoleto, ÚNICAMENTE para laboratorio aislado"
- Deshabilitar exposición innecesaria de puertos al host
- Usar `.dockerignore` para evitar subir archivos sensibles
- Comentar cada sección del compose para facilitar mantenimiento

## ✅ Criterios de Aceptación / Validación
Proporciona comandos para verificar:
1. `docker-compose ps` → los 3 servicios en estado "healthy" o "up"
2. Conexión PHP → MySQL: `curl http://localhost:8080/test-db.php` (incluir script de prueba)
3. Resolución de hostnames: `docker exec kali ping db.ferreteria.local`
4. Persistencia: Detener/eliminar contenedor MySQL y verificar que los datos permanecen en `./data/mysql`
5. Acceso Kali: `docker exec -it kali bash` y probar conexión a MySQL desde allí

# FORMATO DE RESPUESTA ESPERADO
1. 📋 `docker-compose.yml` completo y comentado
2. 🐳 `Dockerfile.php` (si requiere personalización)
3. 🗄️ Script `init-db.sh` para inicialización de BD
4. 🔧 Archivo `.env.example` con variables documentadas
5. 📖 README.md con:
   - Instrucciones de despliegue paso a paso
   - Comandos de validación
   - Advertencias de seguridad
   - Solución de problemas comunes
6. 🧪 Scripts de prueba opcionales (healthcheck, test-conexion)

# NOTAS ADICIONALES
- Priorizar reproducibilidad: cualquier desarrollador debe poder ejecutar `docker-compose up -d` y que funcione
- Si alguna imagen legacy no está disponible en Docker Hub, sugerir alternativa o build desde source
- Considerar usar `depends_on` con condiciones de salud para orden de inicio correcto