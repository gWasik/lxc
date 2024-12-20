# GitHUB

https://github.com/gWasik/lxc

# lxc

https://community-scripts.github.io/ProxmoxVE/scripts

## ASCII ART

https://patorjk.com/software/taag/#p=display&f=Chunky&t=Update%20VM%20and%20CT

## manual

add to my lxc

```
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

```

## for all containers

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-containers.sh)"
```
