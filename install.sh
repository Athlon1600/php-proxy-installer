#!/bin/bash

# will throw  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=728775 if run with | bash

# debian forks only

# Apache site settings
SITE=php_proxy.conf

# Apache file to where this will be written
CONF_FILE=/etc/apache2/sites-available/$SITE

# How much RAM should be allocated to each Apache process? This is measured in kB (kilobytes) because MemTotal below is given in kB
# RSS for an average apache2 php-proxy instance is anywhere from 10-15 MB
# Actual unique memory taken up by each is 2-5 MB. Factor in all the "shared memory", and the real average should be about 5 MB
APACHE_PROCESS_MEM=5000

function check_apache(){

	# check if directory exist
	if [ -d /etc/apache2/ ]; then
		echo "Apache2 is already installed on this system. This installation only works on fresh systems"
		exit
	fi
}

function check_www(){

	# check if directory exist
	if [ -d "/var/www/" ]; then
		echo "Contents of /var/www/ will be removed."
		read -p "Do you want to continue? [Y/n] "
		
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -rf /var/www/
		else
			exit
		fi
	fi
}

function install_cron(){

	# brackets = list of commands to be executed as one unit
	# restart apache every 12 hours
	crontab -l | { cat; echo "0 0,12 * * * service apache2 restart"; } | crontab -
	
	# update php-proxy-app everyday on midnight
	crontab -l | { cat; echo "0 0 * * * /usr/local/bin/composer update --working-dir=/var/www/"; } | crontab -
}

function update(){

	# dist upgrades
	apt-get -qq update
	apt-get -qq -y upgrade
}

function install_composer(){

	# install composer
	curl -sS https://getcomposer.org/installer | php -d suhosin.executor.include.whitelist=phar
	mv composer.phar /usr/local/bin/composer

	# preserve those command arguments for every composer call
	alias composer='php -d suhosin.executor.include.whitelist=phar /usr/local/bin/composer'
}

# should we even run this script?
check_apache

# does /var/www/ already exist?
check_www

## fresh installations may need to update package locations
update

## git for composer and bc for math operations - vnstat for bandwidth
apt-get -y install git bc curl vnstat

# How much RAM does this computer even have? This will be in kilobytes
MEM_TOTAL=$( grep MemTotal /proc/meminfo | awk '{print $2}' )

# How much of that RAM should be set aside exclusively for Apache?
APACHE_MEM=$( echo "$MEM_TOTAL * 0.90 / 1" | bc  )

# MaxClients = Usable Memory / Memory per Apache process
MAX_CLIENTS=$(( $APACHE_MEM / $APACHE_PROCESS_MEM )) 


# LAMP setup
apt-get -qq -y install apache2 php libapache2-mod-php php-curl php-mbstring

# we need these mods
a2enmod status

# we don't need these mods. -f to avoid "WARNING: The following essential module will be disabled"
a2dismod -f deflate alias rewrite

install_composer

# remove default stuff from apache home directory
# post 2.4: The default Ubuntu document root is /var/www/html.
rm -rf /var/www/*

## remove old apache configurations
rm -rf /etc/apache2/sites-available/*
rm -rf /etc/apache2/sites-enabled/*

## create a new configuration file and write our own
touch $CONF_FILE

echo "Writing to a configuration file $CONF_FILE...";

cat > $CONF_FILE <<EOL
ServerName localhost

<VirtualHost *:80>
	DocumentRoot /var/www/
</VirtualHost>

ServerLimit $MAX_CLIENTS

<IfModule mpm_prefork_module>
    StartServers        5
    MinSpareServers     5
    MaxSpareServers     10
    MaxClients          $MAX_CLIENTS
    MaxRequestsPerChild 0
</IfModule>

ExtendedStatus On

<Location /proxy-status>
	SetHandler server-status
</Location>

EOL


## enable our new site - sometimes it's SITE.conf and other times it's just SITE
a2ensite $SITE
service apache2 restart

composer create-project athlon1600/php-proxy-app:dev-master /var/www/ --no-interaction

# optimize composer
composer dumpautoload -o --working-dir=/var/www/

install_cron
