#!/usr/bin/env bash

# Get installation timestamp
INSTALL_DATE="$(date +%s)"

# Function to prompt for yes/no input
prompt_yes_no() {
  while true; do
    read -p "$1 (y/n): " yn
    case $yn in
      [Yy]* ) return 0;;  # Return 0 for yes
      [Nn]* ) return 1;;  # Return 1 for no
      * ) echo "Please answer yes or no.";;
    esac
  done
}

# Check if user wants to wipe and install
if prompt_yes_no "Do you want to wipe and install?"; then
  echo "Starting install..."
else
  exit 0
fi

# Enable network time protocol
timedatectl set-ntp true

# Check disk type and partition accordingly
if [[ -f "/dev/sda" ]]; then
  fdisk -c /usr/lib/install_tools/partition_script /dev/sda

  mkfs.fat -F32 -n boot    /dev/sda1
  mkfs.ext4     -L system  /dev/sda2
  mkfs.ext4     -L misc    /dev/sda3
  mkfs.btrfs    -L usrdata /dev/sda4
elif [[ -f "/dev/mmcblk0" ]]; then
  fdisk -c /usr/lib/install_tools/partition_script /dev/mmcblk0

  mkfs.fat -F32 -n boot    /dev/mmcblk0p1
  mkfs.ext4     -L system  /dev/mmcblk0p2
  mkfs.ext4     -L misc    /dev/mmcblk0p3
  mkfs.btrfs    -L usrdata /dev/mmcblk0p4
fi

# Mount partitions
mkdir -p /mnt/setup
mount -L system /mnt/setup

mkdir -p /mnt/setup/boot/EFI
mkdir -p /mnt/setup/misc
mkdir -p /mnt/setup/home

mount LABEL=boot /mnt/setup/boot/EFI
mount -L misc    /mnt/setup/misc
mount -L usrdata /mnt/setup/home

# Install software based on available packages or squashfs image
if [[ -f "/run/archiso/bootmnt/"*"/$(uname -m)/airootfs.sfs" ]]; then
  unsquashfs "/run/archiso/bootmnt/"*"/$(uname -m)/airootfs.sfs" -d /mnt/setup
else
  pacstrap -c /mnt/setup - < /etc/orchid/packages_list.txt
  cp /usr/lib/install_tools/rootfs/* /mnt/setup/
fi

# Generate fstab
genfstab -U /mnt/setup > /mnt/setup/etc/fstab

# Configure swap, timezone, locale, and install bootloader
arch-chroot /mnt/setup <<EOF
dd if=/dev/zero of=/swapfile bs=1M count=512 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo "/swapfile none swap 0 0" >> /etc/fstab

hwclock --systohc
locale-gen

if [[ "$(uname -m)" == "x86_64" ]]; then
  grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
  grub-mkconfig -o /boot/grub/grub.cfg
fi

exit
EOF

# Save installation timestamp
echo "$INSTALL_DATE" > "/mnt/setup/misc/installs/$INSTALL_DATE.txt"
echo "Installed successfully! You can reboot to your install now."

# Unmount partitions
if [[ -f "/dev/sda" ]]; then
  umount -l /dev/sda1
  umount -l /dev/sda3
  umount -l /dev/sda4
  umount -l /dev/sda2
elif [[ -f "/dev/mmcblk0" ]]; then
  umount -l /dev/mmcblk0p1
  umount -l /dev/mmcblk0p3
  umount -l /dev/mmcblk0p4
  umount -l /dev/mmcblk0p2
fi
