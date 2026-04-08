# GitHUB

https://github.com/gWasik/lxc

https://github.com/gWasik/notes

# lxc

https://community-scripts.github.io/ProxmoxVE/scripts

## ASCII ART

https://patorjk.com/software/taag/#p=display&f=Graffiti&t=PVE1

## manual

### exec on my OpenWRT
```
ash -c "$(curl -fsSL https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-owrt.sh)"

[ -f ~/.bash_history ] && sed -i -e '/_termius_/d' -e '/builtin printf.*?1049/d' ~/.bash_history; [ -f /etc/openwrt_release ] && [ -z "$(ls -A /var/opkg-lists 2>/dev/null)" ] && ash -c "$(wget -qO- https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-owrt.sh)"; mc
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

# timezone manual correction debian

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-containers.sh)"
```

```
sudo timedatectl set-timezone Europe/Moscow

cat docker-compose.yml
...
    volumes:
...
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
...
docker compose down && docker compose up -d && docker compose logs -f -t
```

# proxmox scripts

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/PVE/openwrt24.10-vm.sh)"

wget --no-check-certificate -qO- https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/PVE/expand-root.sh | ash

wget --no-check-certificate -qO- https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-owrt.sh | ash

wget --no-check-certificate -qO- https://raw.githubusercontent.com/gWasik/Passwall/main/passwallx.sh | ash

```