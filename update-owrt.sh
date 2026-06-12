#!/bin/sh

# add and update packets
opkg update && opkg install htop sudo mc iperf3 curl wget tcpdump iftop mtr atop autossh openssh-sftp-server openssh-client ca-bundle

#my motd
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/welcome.sh" "-O" "/etc/welcome.sh"
chmod a+x /etc/welcome.sh
grep -qxF "/etc/welcome.sh" /etc/profile || (echo "" >> /etc/profile && echo "/etc/welcome.sh" >> /etc/profile)
[ -f /etc/banner ] && mv /etc/banner /etc/banner.awasiksave

mkdir -p ~/.ssh
#add ssh key
[ -s /root/.ssh/authorized_keys ] && [ -n "$(tail -n1 /root/.ssh/authorized_keys | tr -d '\r\n')" ] && echo "" >> /root/.ssh/authorized_keys; wget -qO- "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" >> /root/.ssh/authorized_keys && awk '!seen[$0]++' /root/.ssh/authorized_keys > /root/.ssh/authorized_keys.tmp && mv /root/.ssh/authorized_keys.tmp /root/.ssh/authorized_keys
chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
#
#sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
#sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
#systemctl restart sshd

