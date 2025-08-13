# Code Server con Laravel + React + InertiaJS
FROM lscr.io/linuxserver/code-server:latest

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    zip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Instalar PHP 8.2 y extensiones necesarias para Laravel
RUN add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
    php8.2 \
    php8.2-cli \
    php8.2-common \
    php8.2-curl \
    php8.2-zip \
    php8.2-gd \
    php8.2-mysql \
    php8.2-pgsql \
    php8.2-xml \
    php8.2-mbstring \
    php8.2-intl \
    php8.2-bcmath \
    php8.2-sqlite3 \
    php8.2-tokenizer \
    php8.2-fileinfo \
    php8.2-dom \
    php8.2-pdo \
    php8.2-iconv \
    php8.2-simplexml \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Verificar instalación de Composer
RUN composer --version

# Instalar Node.js 22 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Instalar herramientas globales de Node.js
RUN npm install -g \
    yarn \
    pnpm \
    @vue/cli \
    vite \
    create-react-app \
    @vitejs/create-app

# Instalar Laravel Installer globalmente
RUN composer global require laravel/installer

# Añadir composer global bin al PATH
ENV PATH="/root/.composer/vendor/bin:$PATH"

# Configurar Git (valores por defecto, se pueden sobrescribir)
RUN git config --global user.name "Adonay Gutierrez" && \
    git config --global user.email "adonaygutierrez50@gmail.com" && \
    git config --global init.defaultBranch main

# Crear directorios necesarios
RUN mkdir -p /config/workspace /config/scripts

# Copiar scripts de desarrollo
COPY scripts/ /config/scripts/
RUN chmod +x /config/scripts/*.sh

# Configurar PHP para desarrollo
RUN echo "memory_limit = 512M" >> /etc/php/8.2/cli/php.ini && \
    echo "max_execution_time = 300" >> /etc/php/8.2/cli/php.ini && \
    echo "upload_max_filesize = 100M" >> /etc/php/8.2/cli/php.ini && \
    echo "post_max_size = 100M" >> /etc/php/8.2/cli/php.ini

# Exponer solo el puerto de code-server
EXPOSE 8443

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8443 || exit 1
