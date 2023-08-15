# Setting up Server Blocks for Nginx #

```shell
$ sudo mdkir -p /var/www/exampledomain.com/html
```

```shell
$ sudo chown -R $USER:$USER /var/www/exampledomain.com/html
```

```shell
$ sudo chmod -R 755 /var/www/exampledomain.com
```

```shell
$ sudo nano /var/www/exampledomain.com/html/index.html # see ./index.html
```

```shell
$ sudo nano /etc/nginx/sites-available/exampledomain.com # see ./exampledomain.com
```

```shell
$ sudo ln -s /etc/nginx/sites-available/exampledomain.com /etc/nginx/sites-enabled/
```

```shell
$ sudo nano /etc/nginx/nginx.conf
```

Uncomment the line `server_names_hash_bucket_size 64;`

```shell
$ sudo nginx -t
```

```shell
$ sudo systemctl restart nginx
```