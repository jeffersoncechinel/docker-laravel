FROM php:7.3.6-fpm-alpine3.9
RUN apk add wget bash mysql-client
RUN docker-php-ext-install pdo pdo_mysql

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

WORKDIR /var/www
RUN rm -rf /var/www/public
COPY . /var/www
RUN ln -s public html

RUN composer install \
    && php artisan config:cache \
    && chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage

EXPOSE 9000
ENTRYPOINT ["php-fpm"]


