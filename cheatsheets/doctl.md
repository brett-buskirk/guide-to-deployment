# `doctl` Commands #

_These commands assume you have the [doctl](https://docs.digitalocean.com/reference/doctl/) CLI installed on your local machine._

## Query Commands ##

Retrieve your DigitalOcean account details:

```shell
doctl account get
```

Retrieve a list of the SSH keys you've added to DigitalOcean:

```shell
doctl compute ssh-key list
```

Retrieve a list of the droplets you've created on DigitalOcean:

```shell
doctl compute droplet list
```

Retrieve a list of the firewalls you've created on DigitalOcean:

```shell
doctl compute firewall list
```

Retrieve the IPv4 address for a specific droplet:

```shell
doctl compute droplet get indianatrektribe.online --format PublicIPv4
```

---

## Creation Commands ##

Create a droplet:

```shell
doctl compute droplet create --image debian-12-x64 --size s-1vcpu-2gb --region nyc1 --enable-monitoring --ssh-keys 39125477 --tag-name webserver indianatrektribe.online
```

Create a firewall:

```shell
doctl compute firewall create --name webserver-firewall \
 --droplet-ids 370152202 \
 --inbound-rules "protocol:tcp,ports:22,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:80,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:443,address:0.0.0.0/0,address:::/0" \
 --outbound-rules "protocol:icmp,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:all,address:0.0.0.0/0,address:::/0 protocol:udp,ports:all,address:0.0.0.0/0,address:::/0"
```

---

## Domain and DNS Commands ##

Add a domain to DigitalOcean:

```shell
doctl compute domain create indianatrektribe.online
```

Add apex domain `A` record to domain:

```shell
doctl compute domain records create indianatrektribe.online --record-type A --record-name @ --record-data 192.241.131.184
```

Add `www` prefix domain `A` record to domain:

```shell
doctl compute domain records create indianatrektribe.online --record-type A --record-name www --record-data 192.241.131.184
```

Add DCV `CNAME` record to domain:

```shell
doctl compute domain records create indianatrektribe.online --record-type CNAME --record-name [Host (but without .indianatrektribe.online)] --record-data [Target (with a . added at the end)] --record-ttl 30
```

---

## Miscellaneous Commands ##

Import a public SSH key into DigitalOcean:

```shell
doctl compute ssh-key import do-key-rsa --public-key-file ~/.ssh/do-key-rsa.pub
```

Remotely access a droplet as the root user:

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa
```

Remotely access a droplet as a specific user:

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa --ssh-user brett
```

---

## Online Documentation ##

You can find full online documentation for `doctl` commands at: [Doctl Command Reference](https://docs.digitalocean.com/reference/doctl/reference/)
