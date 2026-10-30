FROM php:8.5-apache

ARG TIMEZONE="Europe/Paris"
ENV DEBIAN_FRONTEND=noninteractive

# ── System tools ────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    acl \
    ca-certificates \
    curl \
    git \
    gnupg \
    nano \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# ── PHP extensions (install-php-extensions gère les dépendances) ────
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions \
    gd \
    intl \
    opcache \
    pdo_mysql \
    zip \
    apcu \
    redis \
    xdebug

# ── Timezone ────────────────────────────────────────────────────────
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo ${TIMEZONE} > /etc/timezone

# ── Apache modules ─────────────────────────────────────────────────
RUN a2enmod rewrite headers

# ── Composer ────────────────────────────────────────────────────────
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# ── Symfony : DocumentRoot sur /public ──────────────────────────────
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
