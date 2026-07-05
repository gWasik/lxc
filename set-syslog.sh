#!/bin/sh

# add packets
sudo apt update && sudo apt upgrade && sudo apt install -y bat htop btop net-tools ufw iperf3 iftop jq atop lsof ncdu bind9-dnsutils inetutils-traceroute mtr-tiny bc netcat-openbsd netcat-traditional curl wget
sudo apt update && sudo apt upgrade && sudo apt autoremove -y

echo 'alias bat="batcat"' >> ~/.bashrc

sudo systemctl stop exim4
sudo systemctl disable exim4

#ufw
sudo ufw logging off
sudo ufw allow 11111/tcp

sudo journalctl --vacuum-time=2d
sudo sed -i -E 's/^#?SystemMaxUse=.?*$/SystemMaxUse=50M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald

#add rsyslog 
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/rsyslog.d/remote.conf" "-O" "/etc/rsyslog.d/remote.conf"
sudo apt-get install rsyslog -y
rsyslogd -N1
sudo systemctl restart rsyslog
logger "message"

#docker log 
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/docker/daemon.json" "-O" "/etc/docker/daemon.json"
sudo systemctl stop docker.service
sudo systemctl reset-failed docker.service docker.socket
sudo systemctl start docker.service

#установка временной зоны MSK
sudo timedatectl set-timezone Europe/Moscow

#ssh
sudo sed -i -E 's/^#?Port 22/Port 11111/' /etc/ssh/sshd_config
sudo sed -i -E 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i -E 's/^#?ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
if sshd -t; then
    sudo systemctl restart sshd
    echo "SSH успешно перезапущен."
else
    echo "Ошибка: конфигурация некорректна. Перезапуск отменен."
    # Можно добавить команду для детального просмотра ошибки:
    sshd -t
    exit 1
fi

#resolvconf
[ -d "/etc/resolvconf" ] || mkdir -p "/etc/resolvconf"
[ -d "/etc/resolvconf/resolv.conf.d" ] || mkdir -p "/etc/resolvconf/resolv.conf.d"
sudo "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/resolvconf/resolv.conf.d/head" "-O" "/etc/resolvconf/resolv.conf.d/head"
sudo "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/resolvconf/resolv.conf.d/base" "-O" "/etc/resolvconf/resolv.conf.d/base"
[ -d "/etc/systemd" ] || mkdir -p "/etc/systemd"
sudo "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/systemd/resolved.conf" "-O" "/etc/systemd/resolved.conf"

sudo resolvconf -u
nslookup ya.ru