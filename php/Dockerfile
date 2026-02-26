# ETAPA 1: Builder (para descargar el código)
FROM alpine:latest AS builder
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/alexbob17/Proyecto-Sistema-Pos-Ferreteria-U2020.git .

# ETAPA 2: Runtime (Imagen final ligera)
# Nota: Cambiamos a Alpine. Alpine usa 'apk' en lugar de 'apt-get'
FROM php:7.4-apache AS runtime 
# (Si tu app permite usar fpm+nginx, alpine sería aún más pequeño, 
# pero mantendremos apache por compatibilidad con tu código legacy)

# Instalamos dependencias y extensiones en pasos separados para debug
RUN apt-get update --allow-releaseinfo-change
RUN apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd mysqli pdo pdo_mysql mbstring
RUN rm -rf /var/lib/apt/lists/*

# Copiamos solo el código desde la etapa builder
COPY --from=builder /app /var/www/html/
COPY test-db.php /var/www/html/test-db.php

# Permisos mínimos necesarios
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

RUN a2enmod rewrite
# RUN service apache2 restart

EXPOSE 80