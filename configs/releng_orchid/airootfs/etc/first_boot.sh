#!/bin/bash

set -e

ping -c 1 "8.8.8.8" &> /dev/null
if [ $? -eq 0 ]; then
  sudo pacman-keys --init
  sudo pacman -Syu archlinux-keyring
else
  echo "No internet connection found."
fi
