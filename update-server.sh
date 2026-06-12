#!/bin/sh

# add packets
sudo apt update && sudo apt upgrade && apt install -y htop btop net-tools mc ufw iperf3 curl wget sudo iftop mtr jq atop lsof ncdu dnsutils inetutils-traceroute mtr-tiny bc netcat iproute
sudo apt autoremove -y
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