#!/usr/bin/env bash

sudo apt-get update && sudo apt-get -y upgrade

sudo apt-get -y install nginx

# TODO: maybe go with just php-fpm?
sudo apt-get -y install php7.4-fpm

## missing extensions
sudo apt-get -y install php7.4-curl php7.4-mbstring

## TODO: change php.ini here
sudo service php7.4-fpm restart

## Installation dir
mkdir -p /var/www/proxy

## Installation
sudo apt-get -y install composer
composer create-project athlon1600/php-proxy-app:dev-master /var/www/proxy --no-interaction

## Download configuration
wget https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/nginx/ubuntu20.conf -O /etc/nginx/sites-available/default

## Enable status page for PHP-FPM at: /fpm_status
sed -i -e "s/;pm.status_path = \/status/pm.status_path = \/fpm_status/g" /etc/php/7.4/fpm/pool.d/www.conf

sudo service php7.4-fpm restart
sudo service nginx restart

## SSL tools
sudo apt-get -y install certbot python3-certbot-nginx
