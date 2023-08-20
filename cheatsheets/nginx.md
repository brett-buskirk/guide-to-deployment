# Nginx Commands #

_Note that these commands are run on the remote host by a sudo user._

## Installing and Configuring Nginx ##

Install Nginx:

```shell
sudo apt install nginx
```

Checking the status of the Nginx service:

```shell
systemctl status nginx
```

Create the necessary directory structure for the project files:

```shell
sudo mkdir -p /var/www/indianatrektribe.online/html
```

Make sure the current user is the owner of the directory:


```shell
sudo chown -R $USER:$USER /var/www/indianatrektribe.online/html
```

Set the appropriate permissions for the directory:

```shell
sudo chmod -R 755 /var/www/indianatrektribe.online
```

Set up a server block with the correct directives that point to your custom web root:

```shell
sudo nano /etc/nginx/sites-available/indianatrektribe.online
```

Note that this opens up a text editor, where you'll want to add the following template: [http-server-block](https://github.com/brett-buskirk/guide-to-deployment/blob/main/nginx-server-blocks/http-server-block)

Enable this server block by creating a symbolic link to your custom configuration file inside the `sites-enabled` directory, which Nginx reads during startup:

```shell
sudo ln -s /etc/nginx/sites-available/indianatrektribe.online /etc/nginx/sites-enabled/
```

Delete the default enabled site:

```shell
sudo rm /etc/nginx/sites-enabled/default
```

To avoid a possible hash bucket memory problem that can arise from adding additional server names to your configuration, it is necessary to adjust a single value in the `/etc/nginx/nginx.conf` file. Open the file:

```shell
sudo nano /etc/nginx/nginx.conf
```

Find the `server_names_hash_bucket_size` directive and remove the `#` symbol to uncomment the line:

```
...
http {
    ...
    server_names_hash_bucket_size 64;
    ...
}
...
```

Make sure all the configurations are correct:

```shell
sudo nginx -t
```

Restart the Nginx service:

```shell
sudo systemctl restart nginx
```

---

## Basic Nginx Commands ##

```shell
sudo systemctl stop nginx
```

```shell
sudo systemctl start nginx
```

```shell
sudo systemctl restart nginx
```

```shell
sudo systemctl reload nginx
```

```shell
sudo systemctl disable nginx
```

```shell
sudo systemctl enable nginx
```

---

## Online Documentation ##

You can find full online documentation at [Nginx](https://www.nginx.com)
