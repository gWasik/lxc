# GitHUB

https://github.com/gWasik/lxc

# lxc

https://community-scripts.github.io/ProxmoxVE/scripts

## ASCII ART

https://patorjk.com/software/taag/#p=display&f=Graffiti&t=PVE1

## manual

### exec on my OpenWRT
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-server.sh)"
```

### exec on my VDS/PVE
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-server.sh)"
```

### exec on my LXC
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-container.sh)"
```

```
hostnamectl set-hostname *node*.wasik.ru
mcedit /etc/hosts

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
```

## for all containers

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-containers.sh)"
```
