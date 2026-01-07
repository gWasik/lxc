#!/bin/sh

# --- Настройка стилей ---
# В ash используем универсальный способ задания цветов
tcDkG="\033[01;30m"   # Серый
YW="\033[33m"         # Желтый
GN="\033[1;92m"       # Зеленый
BL="\033[36m"         # Голубой
RD="\033[01;31m"      # Красный
CL="\033[0m"          # Сброс
TAB="  "

ICON_HOST="🏠"
ICON_IP="💡"
ICON_DEF="⚙️"
ICON_DISK="💾"
ICON_LOAD="📈"

# --- Сбор данных (совместимый с BusyBox) ---
# Имя хоста и IP
HOSTNAME_F=$(cat /proc/sys/kernel/hostname)
IP=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n1)

# Uptime (универсальный парсинг)
uptime_raw=$(cat /proc/uptime | cut -d. -f1)
upD=$((uptime_raw / 86400))
upH=$(( (uptime_raw % 86400) / 3600 ))
upM=$(( (uptime_raw % 3600) / 60 ))

# RAM (совместимый с free в BusyBox)
MEM_INFO=$(free | grep "Mem:")
mem_total=$(echo $MEM_INFO | awk '{print $2}')
mem_used=$(echo $MEM_INFO | awk '{print $3}')
MEM_PERC=$(awk "BEGIN {printf \"%.1f\", ($mem_used/$mem_total)*100}")

# Диск (df в BusyBox)
DISK_INFO=$(df -h / | grep /)
DISK_PERC=$(echo $DISK_INFO | awk '{print $5}')
DISK_FREE=$(echo $DISK_INFO | awk '{print $4}')

# Load Average
L_AVG=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')

# --- Логотип ---
# В OpenWrt обычно нет systemd-detect-virt, поэтому по умолчанию выводим стандарт
raw_logo="
________                       __      _______________________
\_____  \ ______   ____   ____/  \    /  \______   \__    ___/
 /   |   \\____ \_/ __ \ /    \   \/\/   /|       _/ |    |   
/    |    \  |_> >  ___/|   |  \        / |    |   \ |    |   
\_______  /   __/ \___  >___|  /\__/\  /  |____|_  / |____|   
        \/|__|        \/     \/      \/   aWasik \/
"

# --- Функция вывода (POSIX-совместимая) ---
#label_w=16
print_line() {
    line_num=$1
    icon=$2
    color=$3
    label=$4
    value=$5

    # Вырезаем нужную строку логотипа через sed
    img_part=$(echo "$raw_logo" | sed -n "${line_num}p")
    
    # Печать через printf (работает везде)
    # Используем фиксированные отступы
    printf "${tcDkG}%-70s${CL}${TAB}${icon}${TAB}${color}%-15s %s${CL}\n" \
        "$img_part" "$label" "$value"
}

# --- Финальный вывод ---
echo ""
print_line 1 "$ICON_HOST" "$YW" "Hostname:"      "$HOSTNAME_F"
print_line 2 "$ICON_IP"   "$GN" "IP Address:"    "$IP"
print_line 3 "$ICON_DEF"  "$BL" "System:"        "OpenWrt/Linux"
print_line 4 "$ICON_DEF" "$BL" "Load Average:"  "$L_AVG"
print_line 5 "$ICON_DEF" "$BL" "Disk Usage:"    "$DISK_PERC ($DISK_FREE free)"
print_line 6 "$ICON_DEF"  "$BL" "Memory used:"   "$MEM_PERC%"
print_line 7 "$ICON_DEF"  "$BL" "System uptime:" "${upD}d ${upH}h ${upM}m"
echo ""