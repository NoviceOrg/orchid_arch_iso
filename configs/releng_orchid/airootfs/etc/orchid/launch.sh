#!/bin/bash

set -e

ORCHID_PROFILE="~/.orchid"

echo "Orchid Launch Service - Ding!"

prepare_service() {
  local service="$1"
  if ! systemctl is-enabled "$service" &> /dev/null; then
    systemctl enable "$service"
  fi
  systemctl start "$service"
}

prepare_service acpid.service
prepare_service bluez.service
prepare_service dbus.service
prepare_service NetworkManager.service
prepare_service pipewire.service
prepare_service tlp.service
prepare_service udev.service

if [[ ! -d "$ORCHID_PROFILE" ]]; then
  exit 0
fi

if [[ ! -d "$ORCHID_PROFILE/webapps" && -f "$ORCHID_PROFILE/Preferences" ]]; then
  rm -rf "$ORCHID_PROFILE/"*
fi

if [[ -d "/usr/lib/orchid_ddm" ]]; then
  "/usr/lib/orchid_ddm/orchid_ddm"
fi
