#!/bin/sh

# add packets
sudo apt update
sudo apt upgrade
sudo apt install -y htop btop net-tools sudo iftop iperf3 mtr mc atop sudo lsof ncdu
sudo apt autoremove -y

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
sudo systemctl restart ssh

#resolvconf
sudo "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/resolvconf/resolv.conf.d/head" "-O" "/etc/resolvconf/resolv.conf.d/head"
sudo "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/resolvconf/resolv.conf.d/base" "-O" "/etc/resolvconf/resolv.conf.d/base"
sudo resolvconf -u
nslookup ya.ru