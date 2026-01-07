#!/bin/sh

# add packets
apt update
apt install -y htop btop net-tools sudo mc

#my motd
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/99-mymotd-generator" "-O" "/etc/update-motd.d/99-mymotd-generator"
chmod a+x /etc/update-motd.d/99-mymotd-generator
mv /etc/motd /etc/motd.bak

#add ssh key
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys"
#
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd