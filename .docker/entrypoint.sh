#!/bin/bash

cp ./.docker/env .env
composer install
php artisan key:generate
php artisan migrate
php-fpm
