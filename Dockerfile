FROM php:8.1-fpm

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN composer install --optimize-autoloader --no-dev

RUN chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

CMD php artisan serve --host=0.0.0.0 --port=80
EXPOSE 80
