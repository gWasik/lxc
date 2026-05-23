#!/bin/sh

# add packets
apt update
apt upgrade
apt install -y htop btop net-tools sudo iftop iperf3 mtr mc atop
apt autoremove -y

#ufw
ufw logging off

#add rsyslog 
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/rsyslog.d/remote.conf" "-O" "/etc/rsyslog.d/remote.conf"
apt-get install rsyslog -y
rsyslogd -N1
systemctl restart rsyslog
logger "message"

"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/docker/daemon.json" "-O" "/etc/docker/daemon.json"
systemctl stop docker.service
systemctl reset-failed docker.service docker.socket
systemctl start docker.service

#установка временной зоны MSK
sudo timedatectl set-timezone Europe/Moscow

#ufw
ufw allow 11111/tcp

#ssh
sudo sed -i -E 's/^#?Port 22/Port 11111/' /etc/ssh/sshd_config
sudo sed -i -E 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i -E 's/^#?ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh