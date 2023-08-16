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
doctl compute droplet create --image debian-12-x64 --size s-1vcpu-2gb --region nyc1 --enable-monitoring --ssh-keys 39125477 indianatrektribe.online
```
```shell
ID           Name                       Public IPv4    Private IPv4    Public IPv6    Memory    VCPUs    Disk    Region    Image            VPC UUID    Status    Tags    Features                    Volumes
370142505    indianatrektribe.online                                                  2048      1        50      nyc1      Debian 12 x64                new               monitoring,droplet_agent     
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