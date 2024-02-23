#!/bin/bash

set -e -u -x

ORCHID_PROFILE="~/.local/share/orchid"

echo "Orchid Launch Service Starting..."

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

if -f "$PATH/protodb"; then
  if -f "$PATH/weston-ctl"; then
    weston-ctl brightness "$(protodb get display.brightness)"
  fi
fi

mkdir -p "$ORCHID_PROFILE"

if [[ "$ORCHID_PROFILE" == "" ]]; then
  exit "Variable ORCHID_PROFILE is undefined"
  exit 1
fi

if [[ -d "$ORCHID_PROFILE/cache" && ! -f "$ORCHID_PROFILE/Preferences" ]]; then
  rm -rf "$ORCHID_PROFILE/"*
fi

if [[ -d "/usr/lib/orchidshell" ]]; then
  "/usr/lib/orchidshell/orchidshell"
fi
if [[ -d "/usr/lib/orchid_ddm" ]]; then
  "/usr/lib/orchid_ddm/orchid_ddm"
fi

exit 0
