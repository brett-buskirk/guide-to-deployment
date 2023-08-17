# Transfer SSH Keys from Root to Sudo User #

_These commands assume you're logged into the machine as a sudo user._

Create the `.ssh` directory on the user's root directory:

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