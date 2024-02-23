#!/bin/bash

set -e -u -x

ping -c 1 "8.8.8.8" &> /dev/null
if [ $? -eq 0 ]; then
  sudo pacman-key --init
else
  echo "No internet connection found."
fi
