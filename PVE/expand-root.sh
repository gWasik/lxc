#!/usr/bin/env bash

opkg update
opkg install parted losetup resize2fs mc

wget -U "" -O ~/expand-root.sh "https://openwrt.org/_export/code/docs/guide-user/advanced/expand_root?codeblock=0"
chmod +x ~/expand-root.sh
~/expand-root.sh
chmod +x /etc/uci-defaults/80-rootfs-resize
chmod +x /etc/uci-defaults/70-rootpt-resize