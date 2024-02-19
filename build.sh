#!/bin/bash

set -e

ARCH=${$1:-x86_64}

DDM_PRODUCT_NAME="orchid_ddm"
INSTALL_PATH="/usr/lib/orchid_ddm"

working_dir="./work"
output_dir="./output"

prepare_frontend() {
  cd "$DDM_PRODUCT_NAME"
  npm install
  npm run "build-linux-$ARCH"
  cp ..
}

build_linux() {
  if [[ -d "configs/releng_orchid/$INSTALL_PATH/" ]]; then
    rm -rf "configs/releng_orchid/$INSTALL_PATH/"
  else
    mkdir -p "configs/releng_orchid/$INSTALL_PATH"
  fi
  cp -r "$DDM_PRODUCT_NAME/dist/linux-unpacked/"* "configs/releng_orchid/airootfs/$INSTALL_PATH/"

  sudo ./archiso/mkarchiso -v -r -w "$working_dir" -o "$output_dir" -a "$ARCH" profile/releng_orchid
}

main() {
  prepare_frontend
  build_linux
}

main
