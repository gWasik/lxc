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
NODE=$(hostname)

function update_container() {
  container=$1
  os=$(pct config "$container" | awk '/^ostype/ {print $2}')

  if [[ "$os" == "ubuntu" || "$os" == "debian" ]]; then
    echo -e "${BL}[Info]${GN} Checking /root/.ssh/authorized_keys_new in ${BL}$container${CL} (OS: ${GN}$os${CL})"

    if pct exec "$container" -- [ -ne /root/.ssh/authorized_keys_new ]; then
      pct exec "$container"  -- "wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys_new"
    else
      echo -e "${RD}[Error]${CL} /root/.ssh/authorized_keys_new found in container ${BL}$container${CL}.\n"
    fi
  else
    echo -e "${BL}[Info]${GN} Skipping ${BL}$container${CL} (not Debian/Ubuntu)\n"
  fi
}

header_info
for container in $(pct list | awk '{if(NR>1) print $1}'); do
  update_container "$container"
done

header_info
echo -e "${GN}The process is complete. The repositories have been switched to community-scripts/ProxmoxVE.${CL}\n"