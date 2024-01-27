#!/usr/bin/env bash

if [[ "$TIMEZONE" == "" ]]; then
  TIMEZONE="America/New_York"
fi

fdisk_seq_boot="g\nn\n\n\n+500M\n"
fdisk_seq_system="n\n\n\n+5G\n"
fdisk_seq_misc="n\n\n\n+50M\n"
fdisk_seq_usrdata="n\n\n\n\n"

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

if [[ "$SKIPC" == "true" ]]; then
  echo "Starting install..."
else
  if prompt_yes_no "Do you want to wipe and install?"; then
    echo "Starting install..."
  else
    exit 0
  fi
fi

timedatectl set-ntp true
echo "${fdisk_seq_boot}${fdisk_seq_system}${fdisk_seq_misc}${fdisk_seq_usrdata}w" | fdisk /dev/sda

echo "Wiping and creating partitions..."

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4

mount /dev/sda2 /mnt

mkdir -p /mnt/boot/EFI
mkdir -p /mnt/misc
mkdir -p /mnt/home

mount /dev/sda1 /mnt/boot/EFI
mount /dev/sda3 /mnt/misc
mount /dev/sda4 /mnt/home

echo "Installing software..."

if [[ -f "/run/archiso/bootmnt/arch/$(uname -m)/rootfs.squashfs" ]]; then
  unsquashfs "/run/archiso/bootmnt/arch/$(uname -m)/rootfs.squashfs" -d /mnt
else
  pacstrap -c /mnt - < /usr/lib/install_tools/packages.txt
  cp /usr/lib/install_tools/rootfs/* /mnt/
fi
genfstab -U /mnt >> /mnt/etc/fstab

mkdir /mnt/dev/block/by-label
ln -s ../../../sda1 /mnt/dev/block/by-label/boot
ln -s ../../../sda2 /mnt/dev/block/by-label/system
ln -s ../../../sda3 /mnt/dev/block/by-label/misc
ln -s ../../../sda4 /mnt/dev/block/by-label/usrdata

echo "Preparing software finalization..."

arch-chroot /mnt <<EOF
dd if=/dev/zero of=/swapfile bs=1M count=512 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo "/swapfile none swap 0 0" >> /etc/fstab

lm -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "localhost" > /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 localhost.localdomain localhost" >> /etc/hosts

grub-install --target=${uname -m}-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

exit
EOF

echo "Installed successfully! You can reboot to your install now."

umount -l /dev/sda1
umount -l /dev/sda3
umount -l /dev/sda4
umount -l /dev/sda2
