#!/bin/sh

# add packets
sudo apt update
sudo apt upgrade
sudo apt install -y htop btop net-tools sudo iftop iperf3 mtr mc atop sudo
sudo apt autoremove -y

#ufw
sudo ufw logging off
sudo ufw allow 11111/tcp

#add rsyslog 
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/rsyslog.d/remote.conf" "-O" "/etc/rsyslog.d/remote.conf"
sudo apt-get install rsyslog -y
rsyslogd -N1
sudo systemctl restart rsyslog
logger "message"

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