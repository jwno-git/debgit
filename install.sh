#!/bin/bash

set -e

echo "!!! Begin Install !!!"
read

sudo apt update && sudo apt install -y \
curl \
gpg

mv /home/$USER/debgit/.config /home/$USER/
mv /home/$USER/debgit/.icons /home/$USER/
mv /home/$USER/debgit/.themes /home/$USER/
mv /home/$USER/debgit/.local /home/$USER/
mv /home/$USER/debgit/Documents /home/$USER/
mv /home/$USER/debgit/.root /home/$USER/
mv /home/$USER/debgit/Pictures /home/$USER/
mv /home/$USER/debgit/.vimrc /home/$USER/
mv /home/$USER/debgit/.zshrc /home/$USER/

sleep 1.0

echo
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sleep 1.0

echo "=== Setting up zram swap early ==="
chmod +x /home/$USER/.local/scripts/zram-setup.sh
/home/$USER/.local/scripts/zram-setup.sh

sleep 1.0

sudo apt update
sudo apt modernize-sources -y
sudo apt install -y \
  bluez \
  brave-browser \
  brightnessctl \
  btop \
  chafa \
  cliphist \
  dunst \
  fastfetch \
  fbset \
  firefox-esr-l10n-en-ca \
  flatpak \
  fonts-font-awesome \
  fonts-terminus \
  gimp \
  grim \
  hyprland \
  imagemagick \
  jq \
  lf \
  lxpolkit \
  network-manager \
  network-manager-applet \
  nftables \
  openssh-client \
  pavucontrol \
  pipewire \
  pipewire-pulse \
  pipewire-audio \
  pipewire-alsa \
  psmisc \
  slurp \
  swappy \
  tar \
  vim \
  waybar \
  wireplumber \
  wf-recorder \
  wget \
  wlogout \
  wofi \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-wlr \
  zsh

sudo apt install -y --no-install-recommends \
  build-essential \
  cmake \
  g++ \
  libpam0g-dev \
  libcairo2-dev \
  libdrm-dev \
  libgbm-dev \
  libgl1-mesa-dev \
  libinput-dev \
  libjpeg-dev \
  libmagic-dev \
  libpango1.0-dev \
  libpugixml-dev \
  libspa-0.2-bluetooth \
  libspng-dev \
  libsdbus-c++-dev \
  libwayland-dev \
  libwebp-dev \
  libxkbcommon-dev \
  make \
  mpv \
  ninja-build \
  pkg-config \
  wayland-protocols

sleep 1.0

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y --user flathub \
	org.kde.kdenlive \
	org.libreoffice.LibreOffice \
	org.gnome.eog \
	com.bitwarden.desktop \
	org.gnome.Calculator \
	org.standardnotes.standardnotes

sleep 1.0

flatpak override --user \
	--filesystem=xdg-config/gtk-3.0 \
	--filesystem=xdg-config/gtk-4.0 \
	--env=GTK_THEME=Tokyonight-Dark \
        --env=HYPRCURSOR_THEME=rose-pine-hyprcursor \
	--env=XCURSOR_THEME=RosePine \
	--env=HYPRCURSOR_SIZE=32 \
        --env=XCURSOR_SIZE=32 \
	--socket=wayland \
	--talk-name=org.freedesktop.portal.Desktop

flatpak override --user org.kde.kdenlive \
  	--filesystem=home \
  	--env=QT_QPA_PLATFORM=wayland

flatpak override --user org.gnome.eog \
  	--filesystem=home

flatpak override --user org.libreoffice.Libreoffice \
	--filesystem=home

sleep 1.0

cd /home/$USER/
mkdir -p /home/$USER/.src
mkdir -p /home/$USER/.src/.zsh
git clone https://github.com/zsh-users/zsh-completions /home/$USER/.src/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting /home/$USER/.src/.zsh/zsh-syntax-highlighting
git clone https://github.com/hyprwm/hyprutils /home/$USER/.src/hyprutils
git clone https://github.com/hyprwm/hyprlang /home/$USER/.src/hyprlang
git clone https://github.com/hyprwm/hyprwayland-scanner /home/$USER/.src/hyprwayland-scanner
git clone https://github.com/hyprwm/hyprgraphics /home/$USER/.src/hyprgraphics
git clone https://github.com/hyprwm/hyprlock /home/$USER/.src/hyprlock
git clone https://github.com/hyprwm/hyprpaper /home/$USER/.src/hyprpaper
git clone https://github.com/hyprwm/hyprpicker /home/$USER/.src/hyprpicker

echo "Hyprutils"
cd /home/$USER/.src/hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
echo

echo "Hyprlang"
cd /home/$USER/.src/hyprlang/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

echo "Hyprwayland-Scanner"
cd /home/$USER/.src/hyprwayland-scanner/
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build
echo

echo "Hyprgraphics"
cd /home/$USER/.src/hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
echo

echo "Hyprlock"
cd /home/$USER/.src/hyprlock/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
echo

echo "Hyprpaper"
cd /home/$USER/.src/hyprpaper/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

echo "Hyprpicker"
cd /home/$USER/.src/hyprpicker/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpicker -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

cd /home/$USER/

sleep 1.0

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

/home/$USER/.local/scripts/nftables-setup.sh
