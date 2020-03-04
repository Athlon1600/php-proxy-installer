# Install PHP-Proxy on your Server

The idea here is to simplify the installation process to the point where one-line is all that's needed to install and configure this app. Paste this command onto your terminal, and make sure you're doing this on a fresh server because this may remove some of your files.


For Ubuntu 14.04:

```shell
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/eeebc9acfbafc07001c4c1f91e837313609a4e77/install.sh)
```

For Ubuntu 16.04:

```shell
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/install.sh)
```

Ubuntu 18:
```console
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/ubuntu18.sh)
```

Ubuntu 19 with nginx + SSL
```console
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/nginx-ubuntu19.sh)

## Install SSL
sudo certbot --nginx --agree-tos --register-unsafely-without-email --redirect
```


![PHP-Proxy Installation](http://i.imgur.com/I5obvni.png?1)

![This is what PHP-Proxy looks like when installed](http://i.imgur.com/BvhBPD0.png?2)

### What does it do?

* apt-get update && apt-get upgrade
* Install Apache + PHP + cURL
* Enable mod_status, and automatically adjust Apache configuration based on the amount of RAM that server has.
* Install Composer
* Via Composer, Install [php-proxy-app](https://github.com/Athlon1600/php-proxy-app)
* Cron job to restart Apache every 12 hours
* Cron job to "composer update" the app every 24 hours.


### To-Do List

* Automatically shut down the server once the bandwidth used exceeds XX terabytes/month.


Feel free to fork this project, and add your own commands to fully customize this for your own individual use.
