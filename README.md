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

### syslog
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/set-syslog.sh)"
```

```
USER_NAME="awasik"
USER_PASS="awasik"

if id "$USER_NAME" &>/dev/null; then
    echo "Пользователь $USER_NAME уже существует"
else
    # Создаем пользователя
    useradd -m -s /bin/bash "$USER_NAME"
    # Назначаем пароль
    echo "$USER_NAME:$USER_PASS" | chpasswd
    # Даем права sudo
    usermod -aG sudo "$USER_NAME"
    echo "Пользователь $USER_NAME успешно создан"
fi

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

# openwrt scripts

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/PVE/openwrt24.10-vm.sh)"

wget --no-check-certificate -qO- https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/PVE/expand-root.sh | ash

wget --no-check-certificate -qO- https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-owrt.sh | ash

opkg update && opkg install htop sudo mc iperf3 curl wget sudo iputils-ping tcpdump iftop adguardhome luci-app-chrony luci-app-dockerman luci-app-filemanager luci-app-nut luci-app-p910nd luci-app-sshtunnel luci-lib-docker luci-proto-wireguard qemu-ga

opkg update && opkg list-upgradable | awk '{print $1}' | xargs opkg upgrade

cd /tmp && rm -f passwall2.sh && wget -O passwall2.sh https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/PVE/passwall2.sh && sh passwall2.sh

```

# NODE

## полезное

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

## WARP native

```
https://github.com/distillium/warp-native/tree/main

https://wiki.egam.es/ru/configuration/warp-native/

bash <(curl -fsSL https://raw.githubusercontent.com/distillium/warp-native/main/install.sh)
```

## remnawave

```
bash <(curl -Ls https://raw.githubusercontent.com/eGamesAPI/remnawave-reverse-proxy/refs/heads/main/install_remnawave.sh)
remnawave_reverse
```

### логи

```
curl -L -o /root/remnanode_analyzer.sh https://raw.githubusercontent.com/OMchik33/Remnawave-scripts/refs/heads/main/remnanode_analyzer.sh && chmod +x /root/remnanode_analyzer.sh && bash /root/remnanode_analyzer.sh
```

## проверки VPS

https://github.com/vernette/ipregion/blob/master/README.md

```
bash <(wget -qO- https://ipregion.vrnt.xyz)
bash <(wget -qO- https://ipregion.vrnt.xyz) --interface warp
bash <(wget -qO- https://ipregion.vrnt.xyz) --proxy 127.0.0.1:1080 # Use SOCKS5 proxy

Проверка IP сервера на блокировки зарубежными сервисами: 
bash <(curl -Ls IP.Check.Place) -l en

Параметры сервера и проверка скорости к российским провайдерам:
wget -qO- speedtest.artydev.ru | bash

Параметры сервера и проверка скорости к зарубежным провайдерам:
wget -qO- bench.sh | bash

Проверка блокировки аудио в Instagram:
bash <(curl -L -s https://bench.openode.xyz/checker_inst.sh)
```