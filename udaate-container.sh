#!/bin/sh

# add packets
apt install -y htop net-tools

#add ssh key
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys"

#add rsyslog 
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/rsyslog.d/remote.conf" "-O" "/etc/rsyslog.d/remote.conf"
apt-get install rsyslog -y
systemctl restart rsyslog
logger "message"

#add cacher dep
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/apt/apt.conf.d/00aptproxy" "-O" "/etc/apt/apt.conf.d/00aptproxy"
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/usr/local/bin/apt-proxy-detect.sh" "-O" "/usr/local/bin/apt-proxy-detect.sh"
chmod a+x /usr/local/bin/apt-proxy-detect.sh

#my motd
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/99-mymotd-generator" "-O" "/etc/update-motd.d/99-mymotd-generator"
chmod a+x /etc/update-motd.d/99-mymotd-generator
mv /etc/motd /etc/motd.bak