#!/bin/bash

set -e

cd /home/$USER/.icons/
tar -xf BreezeX-RosePine-Linux.tar.xz
tar -xf rose-pine-hyprcursor.tar.xz
mv BreezeX-RosePine-Linux RosePine

cd /home/$USER/.themes/
tar -xf Tokyonight-Dark.tar.xz

sudo cp -r /home/$USER/.icons/RosePine /usr/share/icons/
sudo cp -r /home/$USER/.icons/rose-pine-hyprcursor /usr/share/icons/
sudo cp -r /home/$USER/.themes/Tokyonight-Dark /usr/share/themes/

sudo mkdir -p /root/.src
sudo mv /home/$USER/.root/.config /root/
sudo mv /home/$USER/.root/.zshrc /root/
sudo mv /home/$USER/.root/.vimrc /root/
sudo mv /home/$USER/.root/debianlogo.png /root/
sudo cp -r /home/$USER/.zsh /root/.src/

sudo chmod +x /home/$USER/.local/scripts/toggle_record.sh
sudo chmod +x /home/$USER/.local/scripts/toggle_notes.sh
sudo chmod +x /home/$USER/.local/scripts/toggle_term.sh
sudo chmod +x /home/$USER/.local/scripts/help_desk.sh
sudo chmod +x /home/$USER/.local/scripts/vim-term.sh
sudo chmod +x /home/$USER/.local/scripts/volume-notify.sh
sudo chmod +x /home/$USER/.local/scripts/wofi-ssh.sh
sudo chmod +x /home/$USER/.local/scripts/nftables-setup.sh

sleep 1.0
