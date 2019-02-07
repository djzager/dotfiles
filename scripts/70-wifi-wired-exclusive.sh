#!/usr/bin/env bash
# https://matoski.com/article/wifi-ethernet-autoswitch/

name_tag="wifi-wired-exclusive"
syslog_tag="$name_tag"
skip_filename="/etc/NetworkManager/.$name_tag"

if [ -f "$skip_filename" ]; then
  exit 0
fi

interface="$1"
iface_mode="$2"
iface_type=$(nmcli dev | grep "$interface" | tr -s ' ' | cut -d' ' -f2)
iface_state=$(nmcli dev | grep "$interface" | tr -s ' ' | cut -d' ' -f3)

logger -i -t "$syslog_tag" "Interface: $interface = $iface_state ($iface_type) is $iface_mode"

enable_wifi() {
   logger -i -t "$syslog_tag" "Interface $interface ($iface_type) is down, enabling wifi ..."
   nmcli radio wifi on
}

disable_wifi() {
   logger -i -t "$syslog_tag" "Disabling wifi, ethernet connection detected."
   nmcli radio wifi off
}

if [ "$iface_type" = "ethernet" ] && [ "$iface_mode" = "down" ]; then
  enable_wifi
elif [ "$iface_type" = "ethernet" ] && [ "$iface_mode" = "up"  ] && [ "$iface_state" = "connected" ]; then
  disable_wifi
fi
