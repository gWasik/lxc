# GitHUB

https://github.com/gWasik/lxc

# lxc

https://community-scripts.github.io/ProxmoxVE/scripts

## ASCII ART

https://patorjk.com/software/taag/#p=display&f=Graffiti&t=PVE1

## manual

add to my lxc

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-container.sh)"
```
```
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
```

## for all containers

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-containers.sh)"
```
