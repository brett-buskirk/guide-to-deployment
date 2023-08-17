# `doctl` Commands #

_These commands assume you have the [doctl](https://docs.digitalocean.com/reference/doctl/) CLI installed on your local machine._

```shell
doctl account get
```

```shell
doctl compute ssh-key import do-key-rsa --public-key-file ~/.ssh/do-key-rsa.pub
```

```shell
doctl compute ssh-key list
```

```shell
doctl compute droplet create --image debian-12-x64 --size s-1vcpu-2gb --region nyc1 --enable-monitoring --ssh-keys 39125477 --tag-name webserver indianatrektribe.online
```

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa
```

```shell
doctl compute firewall create --name webserver-firewall \
 --droplet-ids 370152202 \
 --inbound-rules "protocol:tcp,ports:22,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:80,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:443,address:0.0.0.0/0,address:::/0" \
 --outbound-rules "protocol:icmp,address:0.0.0.0/0,address:::/0 protocol:tcp,ports:all,address:0.0.0.0/0,address:::/0 protocol:udp,ports:all,address:0.0.0.0/0,address:::/0"
```

```shell
doctl compute droplet list
```

```shell
doctl compute firewall list
```

```shell
doctl compute ssh indianatrektribe.online --ssh-key-path ~/.ssh/do-key-rsa --ssh-user brett
```