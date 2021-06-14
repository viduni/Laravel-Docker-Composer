FROM php:8.0.2-fpm-alpine3.13
ARG UID
RUN apk --update add shadow
RUN usermod -u $UID www-data && groupmod -g $UID www-data
RUN apk --update add sudo
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apk --update add composer
RUN docker-php-ext-install pdo_mysql
RUN apk add --update npm
RUN apk add --update make
RUN apk --update add zlib
RUN apk add --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      php-gd \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*
RUN apk add --no-cache $PHPIZE_DEPS && pecl install xdebug-3.0.2 && docker-php-ext-enable xdebug
RUN apk --update add git
