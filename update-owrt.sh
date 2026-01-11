#!/bin/sh

# add packets
opkg update && opkg install htop sudo mc iperf3 curl wget sudo iputils-ping tcpdump

#my motd
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/welcome.sh" "-O" "/etc/welcome.sh"
chmod a+x /etc/welcome.sh
echo "" >> /etc/profile && echo "/etc/welcome.sh" >> /etc/profile
mv /etc/banner /etc/banner.awasiksave

#add ssh key
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys"
#
#sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
#sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
#systemctl restart sshd