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