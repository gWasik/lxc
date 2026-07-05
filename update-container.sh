#!/bin/sh

# add packets
sudo apt update && sudo apt upgrade && sudo apt install -y htop btop net-tools sudo iftop iperf3 mtr mc atop lsof ncdu
 
#add ssh key
[ -s /root/.ssh/authorized_keys ] && [ -n "$(tail -n1 /root/.ssh/authorized_keys | tr -d '\r\n')" ] && echo "" >> /root/.ssh/authorized_keys; wget -qO- "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" >> /root/.ssh/authorized_keys && awk '!seen[$0]++' /root/.ssh/authorized_keys > /root/.ssh/authorized_keys.tmp && mv /root/.ssh/authorized_keys.tmp /root/.ssh/authorized_keys
chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
#
sudo sed -i 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#?ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
if sshd -t; then
    sudo systemctl restart sshd
    echo "SSH успешно перезапущен"
else
    echo "Ошибка: конфигурация некорректна. Перезапуск отменен."
    # Можно добавить команду для детального просмотра ошибки:
    sshd -t
    exit 1
fi

#add rsyslog 
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/rsyslog.d/remote.conf" "-O" "/etc/rsyslog.d/remote.conf"
apt-get install rsyslog -y
rsyslogd -N1
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

#установка временной зоны MSK
sudo timedatectl set-timezone Europe/Moscow