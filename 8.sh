#!/bin/bash

set -e

cat > /home/$USER/.local/share/applications/bluetoothctl.desktop << 'EOF'
[Desktop Entry]
Name=Bluetooth
Comment=Command-line Bluetooth manager
Exec=sh -c 'sudo systemctl start bluetooth && foot --app-id=bluetooth --title="Bluetooth Control" bluetoothctl'
Icon=bluetooth
Terminal=false
Type=Application
Categories=System;Settings;
EOF

sleep 1.0

sudo sed -i 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf
sudo rm -rf /etc/motd

sudo tee /etc/network/interfaces > /dev/null << 'EOF'
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
EOF

rm -rf /home/$USER/.root
sudo systemctl enable NetworkManager
systemctl --user enable pipewire
systemctl --user enable pipewire-pulse  
systemctl --user enable wireplumber

sleep 1.0
