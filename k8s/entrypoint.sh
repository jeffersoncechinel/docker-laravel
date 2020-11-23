#!/bin/bash

php artisan config:cache
php artisan migrate
rm -rf html
ln -s public html
php-fpm
