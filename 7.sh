#!/bin/bash

set -e

echo "Installing Systemd-Boot"
sudo apt install -y systemd-boot systemd-boot-efi
sudo bootctl --path=/boot/efi install

echo "Removing Grub"
sudo apt purge --allow-remove-essential -y \
  grub-common \
  grub-efi-amd64 \
  grub-efi-amd64-bin \
  grub-efi-amd64-signed \
  grub-efi-amd64-unsigned \
  grub2-common \
  shim-signed \
  ifupdown \
  nano \
  os-prober \
  vim-tiny \
  zutty

sudo apt autoremove --purge -y

sleep 1.0

echo "Current EFI Boot Entries:"
sudo efibootmgr
echo "Enter Boot ID of GRUB to delete (e.g. 0000):"
read -r BOOT_ID
sudo efibootmgr -b "$BOOT_ID" -B

sleep 1.0
