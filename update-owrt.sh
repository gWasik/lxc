#!/bin/sh

# add and update packets
opkg update && opkg install htop sudo mc iperf3 curl wget sudo iputils-ping tcpdump iftop luci-app-wireguard adguardhome luci-app-chrony luci-app-dockerman luci-app-filebrowser luci-app-filemanager luci-app-nut luci-app-p910nd luci-app-sshtunnel luci-app-statistics luci-lib-docker luci-mod-admin-full luci-proto-wireguard
opkg update && opkg list-upgradable | awk '{print $1}' | xargs opkg upgrade

#my motd
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/welcome.sh" "-O" "/etc/welcome.sh"
chmod a+x /etc/welcome.sh
grep -qxF "/etc/welcome.sh" /etc/profile || (echo "" >> /etc/profile && echo "/etc/welcome.sh" >> /etc/profile)
[ -f /etc/banner ] && mv /etc/banner /etc/banner.awasiksave

mkdir -p ~/.ssh
#add ssh key
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys"
#
#sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
#sudo sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
#systemctl restart sshd

