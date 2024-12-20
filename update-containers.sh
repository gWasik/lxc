#!/usr/bin/env bash

function header_info {
  clear
  cat <<"EOF"
 _______           __         __              ___ ___ _______                     __      ______ _______ 
|   |   |.-----.--|  |.---.-.|  |_.-----.    |   |   |   |   |    .---.-.-----.--|  |    |      |_     _|
|   |   ||  _  |  _  ||  _  ||   _|  -__|    |   |   |       |    |  _  |     |  _  |    |   ---| |   |  
|_______||   __|_____||___._||____|_____|     \_____/|__|_|__|    |___._|__|__|_____|    |______| |___|  
         |__|                                                                                            
EOF
}

set -eEuo pipefail
BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")

header_info
echo "Loading..."
whiptail --backtitle "Proxmox VE Helper Scripts" --title "Proxmox VE LXC Updater" --yesno "This Will Update LXC Containers. Proceed?" 10 58 || exit
NODE=$(hostname)
EXCLUDE_MENU=()
MSG_MAX_LENGTH=0
while read -r TAG ITEM; do
  OFFSET=2
  ((${#ITEM} + OFFSET > MSG_MAX_LENGTH)) && MSG_MAX_LENGTH=${#ITEM}+OFFSET
  EXCLUDE_MENU+=("$TAG" "$ITEM " "OFF")
done < <(pct list | awk 'NR>1')
excluded_containers=$(whiptail --backtitle "Proxmox VE Helper Scripts" --title "Containers on $NODE" --checklist "\nSelect containers to skip from updates:\n" 16 $((MSG_MAX_LENGTH + 23)) 6 "${EXCLUDE_MENU[@]}" 3>&1 1>&2 2>&3 | tr -d '"') || exit

function needs_reboot() {
    local container=$1
    local os=$(pct config "$container" | awk '/^ostype/ {print $2}')
    local reboot_required_file="/var/run/reboot-required.pkgs"
    if [ -f "$reboot_required_file" ]; then
        if [[ "$os" == "ubuntu" || "$os" == "debian" ]]; then
            if pct exec "$container" -- [ -s "$reboot_required_file" ]; then
                return 0
            fi
        fi
    fi
    return 1
}


function update_container() {
  container=$1
  os=$(pct config "$container" | awk '/^ostype/ {print $2}')

  if [[ "$os" == "ubuntu" || "$os" == "debian" ]]; then
    
    #authorized_keys
    echo -e "${BL}[Info]${GN} Checking /root/.ssh/authorized_keys in ${BL}$container${CL} (OS: ${GN}$os${CL})"

    if pct exec "$container" -- [ -e /root/.ssh/authorized_keys ]; then
          echo -e "${RD}[Error]${CL} /root/.ssh/authorized_keys found in container ${BL}$container${CL}.\n"
    else
          pct exec "$container"  -- "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys"
    fi
    
    #rsyslog
    echo -e "${BL}[Info]${GN} Checking /etc/rsyslog.d/remote.conf in ${BL}$container${CL} (OS: ${GN}$os${CL})"

    if pct exec "$container" -- [ -e /etc/rsyslog.d/remote.conf ]; then
          echo -e "${RD}[Error]${CL} /etc/rsyslog.d/remote.conf found in container ${BL}$container${CL}.\n"
    else
          pct exec "$container"  -- "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/rsyslog.d/remote.conf" "-O" "/etc/rsyslog.d/remote.conf"
          pct exec "$container"  -- apt-get install rsyslog -y
          pct exec "$container"  -- systemctl restart rsyslog
    fi
    pct exec "$container"  -- logger "$container updated"

    #add cacher dep
    echo -e "${BL}[Info]${GN} Checking /etc/apt/apt.conf.d/00aptproxy in ${BL}$container${CL} (OS: ${GN}$os${CL})"

    pct exec "$container"  -- "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/apt/apt.conf.d/00aptproxy" "-O" "/etc/apt/apt.conf.d/00aptproxy"
    pct exec "$container"  -- "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/usr/local/bin/apt-proxy-detect.sh" "-O" "/usr/local/bin/apt-proxy-detect.sh"
    pct exec "$container"  -- chmod a+x /usr/local/bin/apt-proxy-detect.sh
    
    #my motd
    echo -e "${BL}[Info]${GN} Checking /etc/update-motd.d/99-mymotd-generator in ${BL}$container${CL} (OS: ${GN}$os${CL})"

    if pct exec "$container" -- [ -e /etc/motd ]; then
        pct exec "$container"  -- "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/etc/update-motd.d/99-mymotd-generator" "-O" "/etc/update-motd.d/99-mymotd-generator"
        pct exec "$container"  -- chmod a+x /etc/update-motd.d/99-mymotd-generator
        pct exec "$container"  -- mv /etc/motd /etc/motd.bak
    else
          echo -e "${RD}[Error]${CL} /etc/motd not found in container ${BL}$container${CL}.\n"
    fi

  else
    echo -e "${BL}[Info]${GN} Skipping ${BL}$container${CL} (not Debian/Ubuntu)\n"
  fi
}

containers_needing_reboot=()
header_info
for container in $(pct list | awk '{if(NR>1) print $1}'); do
  if [[ " ${excluded_containers[@]} " =~ " $container " ]]; then
    header_info
    echo -e "${BL}[Info]${GN} Skipping ${BL}$container${CL}"
    sleep 1
  else
    status=$(pct status $container)
    template=$(pct config $container | grep -q "template:" && echo "true" || echo "false")
    if [ "$template" == "false" ] && [ "$status" == "status: stopped" ]; then
      echo -e "${BL}[Info]${GN} Starting${BL} $container ${CL} \n"
      pct start $container
      echo -e "${BL}[Info]${GN} Waiting For${BL} $container${CL}${GN} To Start ${CL} \n"
      sleep 5
      update_container $container
      echo -e "${BL}[Info]${GN} Shutting down${BL} $container ${CL} \n"
      pct shutdown $container &
    elif [ "$status" == "status: running" ]; then
      update_container $container
    fi
    if pct exec "$container" -- [ -e "/var/run/reboot-required" ]; then
        # Get the container's hostname and add it to the list
        container_hostname=$(pct exec "$container" hostname)
        containers_needing_reboot+=("$container ($container_hostname)")
    fi
  fi
done
wait
header_info
echo -e "${GN}The process is complete, and the containers have been successfully updated.${CL}\n"
if [ "${#containers_needing_reboot[@]}" -gt 0 ]; then
    echo -e "${RD}The following containers require a reboot:${CL}"
    for container_name in "${containers_needing_reboot[@]}"; do
        echo "$container_name"
    done
fi

header_info
echo -e "${GN}The process is complete. The containers have been updated${CL}\n"