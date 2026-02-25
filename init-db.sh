#!/bin/bash
set -e

# Se ejecuta dentro del contenedor MySQL durante la inicialización
echo "==> Descargando esquema legacy de Github..."
apt-get update && apt-get install -y wget
wget -q -O /tmp/db.sql https://raw.githubusercontent.com/andrespaucar/sistemaferreteria/master/db.sql

echo "==> Importando esquema a la base de datos $MYSQL_DATABASE..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /tmp/db.sql

echo "==> Importación finalizada con éxito."