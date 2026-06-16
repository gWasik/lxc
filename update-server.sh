#!/bin/sh

# add packets
sudo apt update && sudo apt upgrade && sudo apt install -y bat htop btop net-tools ufw iperf3 iftop jq atop lsof ncdu bind9-dnsutils inetutils-traceroute mtr-tiny bc netcat-openbsd netcat-traditional curl wget mc
sudo apt update && sudo apt upgrade && sudo apt autoremove -y

echo 'alias bat="batcat"' >> ~/.bashrc

ufw allow ssh

#my motd
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/99-mymotd-generator" "-O" "/etc/update-motd.d/99-mymotd-generator"
chmod a+x /etc/update-motd.d/99-mymotd-generator
mv /etc/motd /etc/motd.bak

#add ssh key
[ -s /root/.ssh/authorized_keys ] && [ -n "$(tail -n1 /root/.ssh/authorized_keys | tr -d '\r\n')" ] && echo "" >> /root/.ssh/authorized_keys; wget -qO- "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" >> /root/.ssh/authorized_keys && awk '!seen[$0]++' /root/.ssh/authorized_keys > /root/.ssh/authorized_keys.tmp && mv /root/.ssh/authorized_keys.tmp /root/.ssh/authorized_keys
chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
#
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

#установка временной зоны MSK
sudo timedatectl set-timezone Europe/Moscow