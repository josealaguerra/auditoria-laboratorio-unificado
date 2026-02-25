FROM php:7.4-apache

# Instalar dependencias del SO para las extensiones de PHP y clonar el repo
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configurar e instalar extensiones PHP legacy (gd, mysqli, pdo_mysql, mbstring)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql mbstring

# Limpiar directorio web por defecto y clonar el código legacy
RUN rm -rf /var/www/html/* \
    && git clone https://github.com/alexbob17/Proyecto-Sistema-Pos-Ferreteria-U2020.git /var/www/html/


# RUN rm -rf /var/www/html/* \
#     && git clone https://github.com/alexbob17/Proyecto-Sistema-Pos-Ferreteria-U2020.git /var/www/html/


# Copiar script de prueba de conexión a base de datos
# COPY test-db.php /var/www/html/test-db.php

# Ajustar permisos para Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80