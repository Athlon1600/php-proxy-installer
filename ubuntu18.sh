#!/usr/bin/env bash

sudo apt-get update && sudo apt-get -y upgrade

## git for composer and bc for math operations - vnstat for bandwidth
sudo apt-get -y install git bc curl vnstat

# LAMP setup
sudo apt-get -y install apache2 php libapache2-mod-php php-curl php-mbstring

# We need composer
sudo apt-get -y install composer

# We need youtube-dl too - this takes a while to install....
sudo apt-get -y install youtube-dl

# Apache2 optimization - install what's needed - disable what's not needed.
# -f to avoid "WARNING: The following essential module will be disabled"
a2enmod status
a2dismod -f deflate alias rewrite

sudo systemctl restart apache2
# sudo service apache2 restart

## Download the php_proxy.conf
wget https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/sites-available/php_proxy.conf -O /etc/apache2/sites-available/php_proxy.conf

a2dissite 000-default
a2ensite php_proxy

# restart again
sudo systemctl restart apache2

# remove default stuff from apache home directory
# post 2.4: The default Ubuntu document root is /var/www/html.
rm -rf /var/www/*

# Otherwise you cannot install to non-empty dir
composer create-project athlon1600/php-proxy-app:dev-master /var/www/ --no-interaction


## Enable SSL now

sudo apt-get -y install software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get -y install certbot python-certbot-apache

# https://certbot.eff.org/docs/using.html#certbot-command-line-options
## Will ask for an email. Optional: --email email@email.com
## Will ask for domain. Optional: --domain domain.com
## Make it non-interactive: -n
sudo certbot --apache --agree-tos --redirect

