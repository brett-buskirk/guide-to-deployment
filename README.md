# Hosting and Deploying a Website #

This is a comprehensive guide to hosting and deploying a front-end React website on [DigitalOcean](https://digitalocean.com). In addition, it covers the process of registering a domain and obtaining a SSL certificate through [Namecheap](https://namecheap.com) in order to create a professional and secure website.

---

## Registering a Domain Name ##

The first step here is to make sure you have a domain name secured through a [registrar](https://www.namecheap.com/guru-guides/registries-registrars-and-registrants-what-is-the-difference-dp/). There are several choices out there to choose from, but in this case, we're going to use [Namecheap](https://namecheap.com). This process is fairly straight-forward, and once the transaction is complete, you'll be able to view your domain. Note that when we purchase the domain, we're also going to buy an SSL certificate, as shown in the next section. 

![Domain Registration](./images/deploy-img-domain-registration.png)

---

## Obtaining an SSL Certificate ##

Once we have a domain secured, we'll want to attach an [SSL Certificate](https://www.namecheap.com/security/what-is-ssl-secure-socket-layer-definition/) to it. When you purchase the domain, you will also be given an option to add an SSL certificate to your cart.

An SSL (Secure Sockets Layer) certificate is a digital certificate that authenticates a website's identity and enables an encrypted connection between a web server and a web browser. The certificate is a bit of code on a web server that provides security for online communications. When a web browser contacts a secured website, the SSL certificate enables an encrypted connection. This link ensures that all data passed between the web server and browser remains private.

A website needs an SSL certificate in order to keep user data secure, verify ownership of the website, prevent attackers from creating a fake version of the site, and gain user trust. Without SSL, site visitors and customers are at higher risk of having their data stolen. SSL protects websites from phishing scams, data breaches, and many other threats.

Once you have purchased the SSL certificate, you should be able to see it on the registrar's dashboard.

![SSL Certificate](./images/deploy-img-ssl-certificate-purchase.png)

We'll deal with this some more later. For now, just make sure you have an SSL certificate secured and ready for use.

---

## Create a DigitalOcean Account ##

For this project, we'll be using [DigitalOcean](https://digitalocean.com) as our hosting platform. It is here that you will create your remote virtual machine (VM) in the cloud. You will then provision this machine as a web server to host your website. Setting up an account with DigitalOcean is relatively straightforward. Simply go to the link above and create your account.

---

## Installing doctl ##

DigitalOcean has a handy command line interface (CLI) that we will be using for much of our work. This CLI is called [doctl](https://docs.digitalocean.com/reference/doctl/), and you'll want to follow this link to learn about, install, and configure the CLI for our work throughout this process. Don't forget to create an [API token](https://docs.digitalocean.com/reference/api/create-personal-access-token/) and store it in a safe place, such as your password manager if you have one. Once you have `doctl` installed and configured, you can check this by running the following command in your terminal:

```shell
doctl account get
```

---

## Generate and add SSH Keys to DigitalOcean ##

In order to access your server remotely, you'll need to configure an [SSH key pair](https://www.ssh.com/academy/ssh/keygen) and add the public key to DigitalOcean. You can generate a key pair by running the following commmand:

```shell
ssh-keygen -t rsa -f ~/.ssh/do-key-rsa
```

For this purpose, hit enter when prompted for a password in order to create a passwordless ssh key pair. This will create two files in a directory named `.ssh`. These files are named `do-key-rsa` (the private key) and `do-key-rsa.pub` (the public key).

To add the public key to DigitalOcean, run the following command:

```shell
doctl compute ssh-key import do-key-rsa --public-key-file ~/.ssh/do-key-rsa.pub
```

If successful, you should see some output confirming the key was added, along with the key's FingerPrint. You can also retrieve a list of your keys on DigitalOcean by running:

```shell
doctl compute ssh-key list
```
```shell
ID          Name          FingerPrint
39125477    do-key-rsa    55:5c:ce:7d:b3:6d:89:7b:37:48:bd:25:99:86:ae:eb
```

You'll need to remember the ID of your key, because you'll need it for the next step.

---

## Create a Droplet on DigitalOcean ##

DigitalOcean calls their VMs `droplets`. To create a droplet, run the following command:

```shell
doctl compute droplet create --image debian-12-x64 --size s-1vcpu-2gb --region nyc1 --enable-monitoring --ssh-keys 39125477 --tag-name webserver indianatrektribe.online
```
```shell
ID           Name                       Public IPv4    Private IPv4    Public IPv6    Memory    VCPUs    Disk    Region    Image            VPC UUID    Status    Tags         Features                    Volumes
370152202    indianatrektribe.online                                                  2048      1        50      nyc1      Debian 12 x64                new       webserver    monitoring,droplet_agent    
```

As you can see, you'll get some output showing that the droplet was successfully created. You can also verify this by going to your DigitalOcean dashboard, where you will see the newly-created droplet displayed.

![Digital Ocean Droplet](./images/deploy-img-droplet-creation.png)

Okay, that's a pretty gnarly command, so let's break it down:

* `doctl compute droplet create`: the basic command infrastructure
* `--image debian-12-x64`: The image created (Debian 12 AMD64)
* `--size s-1vcpu-2g`: The size (1 virtual CPU and 2 GB of memory)
* `--region nyc1`: The region where the cloud server is located
* `--enable-monitoring`: Enables monitoring through DigitalOcean for analytics
* `--ssh-keys 39125477`: The ID of your SSH key to be added to the VM
* `--tag-name`: A tag to identify this droplet as a webserver
* `indianatrektribe.online`: The name of the droplet

Once the droplet has been created, you can connect to it remotely by running:

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa
```

You'll want to type `yes` when asked if you want to continue. Afterward, you should be connected to your VM.

```shell
Linux indianatrektribe 6.1.0-9-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.27-1 (2023-05-08) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
root@indianatrektribe:~# 
```

Once you have confirmed this, you can exit the remote host by typing `exit` at the terminal.

---

## Adding a Firewall to your Droplet ##

Now that you have a droplet spun up, it's time to secure it! You only want to allow certian kinds of traffic in and out of your server. This is accomplished by creating a [firewall](https://www.digitalocean.com/community/tutorials/how-to-secure-web-server-infrastructure-with-digitalocean-cloud-firewalls-using-doctl) and attaching it to your droplet.

```shell
doctl compute firewall create --name webserver-firewall \
 --droplet-ids 370152202 \
 --inbound-rules "protocol:tcp,ports:22,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:80,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:443,address:0.0.0.0/0,address:::/0" \
 --outbound-rules "protocol:icmp,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:all,address:0.0.0.0/0,address:::/0 protocol:udp,ports:all,address:0.0.0.0/0,address:::/0"
```

```shell
ID                                      Name                  Status     Created At              Inbound Rules                                                                                                                                                      Outbound Rules                                                                                                                                          Droplet IDs    Tags    Pending Changes
23fd8e14-4bdf-42b5-a0c4-c35ce5272a42    webserver-firewall    waiting    2023-08-16T02:27:19Z    protocol:tcp,ports:22,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:80,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:443,address:0.0.0.0/0,address:::/0    protocol:icmp,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:0,address:0.0.0.0/0,address:::/0 protocol:udp,ports:0,address:0.0.0.0/0,address:::/0    370152202              droplet_id:370152202,removing:false,status:waiting
```

If you can't remember your droplet's ID, you can run:

```shell
doctl compute droplet list
```

You can view your newly-created firewall by running:

```shell
doctl compute firewall list
```

Now, let's go over some of these firewall rules. The settings above allow for the following traffic:

* All inbound SSH (port 22)
* All inbound HTTP (port 80)
* All inbound HTTPS (port 443)
* All outbound ICMP
* All outbound TCP
* All outbound UDP

These rules can be further refined by adding specific port ranges, but such is beyond the scope of this tutorial.

---

## Add Sudo User to the Droplet ##

It's not a good idea to remote into your VM as a root user. Root access is powerful and should only be used with extreme caution. In place of this, you'll want to create a new user and give it root (priveleged) access. First log into your droplet:

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa
```

Create the new user, giving it whatever name you want, by running the following command:

```shell
sudo adduser brett
```

You'll need to supply a password (make sure you remember it!) and answer a few questions (which I typically leave blank), then you'll be prompted if the information is correct.

Next, give your new user sudo priveleges:

```shell
usermod -aG sudo brett
```

Verify these changes by using the following command to switch to your new user:

```shell
su brett
```

Your prompt should change as follows:

```shell
root@indianatrektribe:~# su brett
brett@indianatrektribe:/root$ 
```

Now you can use this user to run root commands by prepending the word `sudo` to them. Run the following:

```shell
sudo apt update && sudo apt upgrade -y
```

You'll have to enter your password the first time you use `sudo` in a session. The command above will update your server and apply any upgrades that might be available.

Now you'll need to transfer the ssh keys from the root user's profile to your new user's profile. To do this you need to run the following commands. First you need to create the `.ssh` directory on the user's root directory:

```shell
mkdir /home/$USER/.ssh
```

Make the directory only executable by the user:

```shell
chmod 700 /home/$USER/.ssh
```

Copy the `authorized_keys` file that contains your public key:

```shell
sudo cp /root/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys
```

Make everything in `.ssh` owned by the user:

```shell
sudo chown -R $USER:$USER /home/$USER/.ssh
```

Make it readable only by the user:

```shell
sudo chmod 600 /home/$USER/.ssh/authorized_keys
```

Now exit the current sessions by running the following command twice:

```shell
exit
```

Now when you remote into the remote host, use:

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa --ssh-user brett
```

You should now be logged in as your new user.

---

## Install `nginx` on the Droplet ##

Before you can actually host a website on your droplet, you must first turn it into a webserver. You can do this with [nginx](https://www.nginx.com/). In order to install nginx, first connect to the remote host with the user you created above. Next, run the following command:

```shell
sudo apt install nginx
```

Now check to make sure the nginx service is running:

```shell
systemctl status nginx
```

You should see some output like the following:

```shell
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Thu 2023-08-17 04:22:50 UTC; 45s ago
       Docs: man:nginx(8)
    Process: 24046 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 24047 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 24070 (nginx)
      Tasks: 2 (limit: 2315)
     Memory: 1.6M
        CPU: 26ms
     CGroup: /system.slice/nginx.service
             ├─24070 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             └─24071 "nginx: worker process"
```

This informs you that the service is up and running.

If everything is configured correctly, you can type your droplet's IP address in a browser and see the following screen:

![Nginx landing page](./images/deploy-img-nginx.png)

`Note:` If you don't know what your droplet's IPv4 address is, use the following command:

```shell
doctl compute droplet get indianatrektribe.online --format PublicIPv4
```

---

## Setting up the Nginx Server Blocks (Part 1) ##

Next you need to set up the Nginx server blocks. When using the Nginx web server, server blocks can be used to encapsulate configuration details. You'll start this process by first creating the necessary directory structure:

```shell
sudo mkdir -p /var/www/indianatrektribe.online/html
```

Next, make sure the current user is the owner of the directory:


```shell
sudo chown -R $USER:$USER /var/www/indianatrektribe.online/html
```

Now set the appropriate permissions for the directory:

```shell
udo chmod -R 755 /var/www/indianatrektribe.online
```

Next you'll need to pull down a set of website files to serve, which we'll cover in the next section.

---

## Pull Down Website to Remote Host from GitHub ##

Now you're going to pull down a repository from GitHub that contains a basic front-end website. Before you can do this, however, you'll need to install `git` on the remote host. You can do this with the following command:

```shell
sudo apt install git
```

Unless you have a repo of your own in mind, you can pull down the `basic-website` project from my GitHub page by running the following command:

```shell
git clone https://github.com/brett-buskirk/basic-website.git
```

Now you need to move all the basic website files to the location from which they will be served:


```shell
sudo mv -v ~/basic-website/* /var/www/indianatrektribe.online/html
```

---

## Setting up the Nginx Server Blocks (Part 2) ##

Next you'll set up a server block with the correct directives that point to your custom web root:

```shell
sudo nano /etc/nginx/sites-available/indianatrektribe.online
```

This will open the `nano` editor, where you'll want to copy the following content:

```
server {
    listen 80;
    listen [::]:80;

    root /var/www/indianatrektribe.online/html;
    index index.html;

    server_name indianatrektribe.online www.indianatrektribe.online;

    location / {
        try_files $uri $uri/ =404;
    }
#    return 301 https://$server_name$request_uri;
}
```

Next, enable this server block by creating a symbolic link to your custom configuration file inside the `sites-enabled` directory, which Nginx reads during startup:

```shell
sudo ln -s /etc/nginx/sites-available/indianatrektribe.online /etc/nginx/sites-enabled/
```

You'll also want to delete the default enabled site:

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

Next, test to make sure that there are no syntax errors in any of your Nginx files:

```shell
sudo nginx -t
```

If everything is okay, you'll see the following output:

```shell
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Once your configuration test passes, restart Nginx to enable your changes:

```shell
sudo systemctl restart nginx
```
