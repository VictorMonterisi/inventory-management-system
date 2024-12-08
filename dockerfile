# PHP (8.4 with Apache)
FROM php:8.4-apache

# Installing essential dependencies 
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql mbstring gd xml \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-enable gd

# Installing Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Installing PHPUnit
RUN curl -Ls https://phar.phpunit.de/phpunit.phar -o /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Set permissions and activate Apache mod_rewrite
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy and move the project code into the container
COPY . /var/www/html

# Default container start command
CMD ["apache2-foreground"]
