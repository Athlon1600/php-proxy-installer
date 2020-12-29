# Install PHP-Proxy on your Server

The idea here is to simplify the installation process to the point where one-line is all that's needed to install and configure this app. Paste this command onto your terminal, and make sure you're doing this on a fresh server because this may remove some of your files.


Ubuntu 20 with nginx + SSL
```console
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/nginx-ubuntu20.sh)

## Install SSL
sudo certbot --nginx --agree-tos --register-unsafely-without-email --redirect
```

Ubuntu 19:
```console
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/nginx-ubuntu19.sh)
```

Ubuntu 18:
```console
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/ubuntu18.sh)
```

For Ubuntu 16.04:

```shell
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/install.sh)
```

For Ubuntu 14.04:

```shell
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/eeebc9acfbafc07001c4c1f91e837313609a4e77/install.sh)
```

Optional PHP config for servers with 1 GB of RAM:

```bash
bash <(wget -O - https://raw.githubusercontent.com/Athlon1600/php-proxy-installer/master/php/php-fpm-1gb.sh)
```


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

### Useful/Debug

How much memory average php-fpm process uses:

```bash
ps -ylC php-fpm7.3 --sort:rss
```

As a single number in megabytes:
```bash
ps --no-headers -o "rss,cmd" -C php-fpm7.3 | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"Mb") }' 
```

Nginx hangs at 100% CPU.

> TCP: out of memory -- consider tuning tcp_mem

Socket leaks.
http://alexhoffman.info/blog/tcp-out-of-memory/

> service php7.3-fpm restart

During composer install

```shell
The "http://repo.packagist.org/p/provider-archived%244b92d0c4ac54205e9b0eb60108508425c627dc43d63463d6800debb88af69674.json" file could not be downloaded: failed to open stream: Connection refused
```
