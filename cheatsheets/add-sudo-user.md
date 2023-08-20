# Adding a Sudo User #

_These commands assume you're logged into the machine as eiher the root or another sudo user._

Create the new user:

```shell
sudo adduser username
```

Add the user to the sudo group:

```shell
usermod -aG sudo username
```

Switch over to the new user:

```shell
su username
```