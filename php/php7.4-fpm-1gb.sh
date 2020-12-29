#!/usr/bin/env bash

## Assume each php-proxy process uses ~25 MB RAM
## Assume 1 GB ram, and we are using 80% of it

# default: 5
sed -i 's/pm.max_children = [0-9]\+/pm.max_children = 40/' /etc/php/7.4/fpm/pool.d/www.conf

## default: 2
sed -i 's/pm.start_servers = [0-9]\+/pm.start_servers = 10/' /etc/php/7.4/fpm/pool.d/www.conf

## default: 1
sed -i 's/pm.min_spare_servers = [0-9]\+/pm.min_spare_servers = 10/' /etc/php/7.4/fpm/pool.d/www.conf

## default: 3
sed -i 's/pm.max_spare_servers = [0-9]\+/pm.max_spare_servers = 20/' /etc/php/7.4/fpm/pool.d/www.conf

## Apply new settings
sudo service php7.4-fpm restart
sudo service nginx restart
