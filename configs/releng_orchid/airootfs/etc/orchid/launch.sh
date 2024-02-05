#!/bin/bash

set -e

ORCHID_PROFILE="~/.orchid"

enable_service() {
  local service="$1"
  if ! systemctl is-enabled "$service" &> /dev/null; then
    systemctl enable "$service"
  fi
  systemctl start "$service"
}

enable_service acpid
enable_service bluez
enable_service dbus
enable_service pipewire
enable_service tlp
enable_service udev

if [[ ! -d "$ORCHID_PROFILE" ]]; then
  exit 0
fi

if [[ ! -d "$ORCHID_PROFILE/webapps" && -f "$ORCHID_PROFILE/Preferences" ]]; then
  rm -rf "$ORCHID_PROFILE/"*
fi

if [[ -d "/usr/lib/orchid_ddm" ]]; then
  "/usr/lib/orchid_ddm/orchid_ddm"
fi
