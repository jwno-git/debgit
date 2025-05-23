#!/bin/bash

set -e

echo "!!! INSTALLING DEBIAN 13 (trixie) AND HYPRLAND !!!"
echo
echo "       Enter to begin or Ctrl + C to cancel       "
read

echo
echo "=== Updating Repo's and installing Apps ==="

sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update
sleep 0.5
echo

sudo apt modernize-sources -y
sleep 0.5
echo

sudo apt install -y \
  blueman \
  bluez \
  brave-browser \
  brightnessctl \
  btop \
  chafa \
  cliphist \
  dunst \
  flatpak \
  fonts-font-awesome \
  fonts-terminus \
  foot \
  grim \
  hyprland \
  imagemagick \
  jq \
  lf \
  lxpolkit \
  network-manager-applet \
  openssh-client \
  pavucontrol \
  pipewire \
  pipewire-pulse \
  pipewire-audio \
  pipewire-alsa \
  psmisc \
  slurp \
  snapper \
  swappy \
  tar \
  terminator \
  waybar \
  wireplumber \
  wget \
  wlogout \
  wofi \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-wlr

sleep 0.5
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
  libspa-0.2-jack \
  libspng-dev \
  libsdbus-c++-dev \
  libwayland-dev \
  libwebp-dev \
  libxkbcommon-dev \
  make \
  ninja-build \
  pkg-config \
  wayland-protocols

sleep 1.0

echo "=== Adding Flathub and installing Flatpaks ==="
sleep 1.0
echo

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo

flatpak install -y flathub \
  com.obsproject.Studio \
  org.kde.kdenlive \
  net.cozic.joplin_desktop \
  org.libreoffice.LibreOffice \
  org.gnome.eog \
  com.bitwarden.desktop \
  org.mozilla.firefox \
  org.gimp.GIMP \
  io.mpv.Mpv \
  org.gnome.Calculator \
  org.standardnotes.standardnotes \

echo "=== Creating Flatpak menu entries ==="
sleep 0.5

update-desktop-database /$HOME/.local/share/appplications/

echo "=== Setting global Flatpak overrides ==="
sleep 0.5

sudo flatpak override --user --filesystem=$HOME/.themes \
	--filesystem=$HOME/.icons \
	--env=GTK_THEME=Tokyonight-Dark \
	--env=XCURSOR_THEME=RosePine \
	--env=XCURSOR_SIZE=32 \
	--socket=wayland \
        --talk-name=org.freedesktop.portal.Desktop \

echo "=== Setting individual overrides ==="
sleep 0.5

flatpak override com.obsproject.Studio --user \
	--filesystem=home \
	--filesystem=xdg-run/pipewire-0 \
  	--env=QT_QPA_PLATFORM=wayland

flatpak override org.kde.kdenlive --user \
  	--filesystem=home \
  	--env=QT_QPA_PLATFORM=wayland

flatpak override org.gnome.eog --user \
  	--filesystem=home

flatpak override io.mpv.Mpv --user \
	--filesystem=home

flatpak override net.cozic.joplin_desktop --user \
	--filesystem=home

flatpak override org.libreoffice.Libreoffice --user \
	--filesystem=home

flatpak override org.gimp.GIMP --user \
	--filesystem=home


echo "=== Building Hypr Packages ==="
sleep 1.0
echo
mkdir -p /$HOME/.src
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/hyprwm/hyprutils ~/.src/hyprutils
git clone https://github.com/hyprwm/hyprlang ~/.src/hyprlang
git clone https://github.com/hyprwm/hyprwayland-scanner ~/.src/hyprwayland-scanner
git clone https://github.com/hyprwm/hyprgraphics ~/.src/hyprgraphics
git clone https://github.com/hyprwm/hyprlock ~/.src/hyprlock
git clone https://github.com/hyprwm/hyprpaper ~/.src/hyprpaper
git clone https://github.com/hyprwm/hyprpicker ~/.src/hyprpicker

sleep 0.5
echo "Hyprutils"
cd ~/.src/hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprlang"
cd ~/.src/hyprlang/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

sleep 0.5
echo "Hyprwayland-Scanner"
cd ~/.src/hyprwayland-scanner/
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprgraphics"
cd ~/.src/hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprlock"
cd ~/.src/hyprlock/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprpaper"
cd ~/.src/hyprpaper/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

sleep 0.5
echo "Hyprpicker"
cd ~/.src/hyprpicker/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpicker -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

cd

echo "  !!! Packages installed and overrides applied !!!  "
echo "Now to install Systemd Boot Loader and Uninstall Grub"
echo "      Enter to continue or CTRL + c to stop.     "
read

sleep 1.0

echo
echo "Installing Systemd-Boot"
echo
sudo apt install -y systemd-boot systemd-boot-efi
echo
sudo bootctl --path=/boot/efi install

echo "Removing Grub"
sleep 1.0
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
  zutty

sudo apt autoremove --purge -y

echo "Current EFI Boot Entries:"
sudo efibootmgr
sleep 1.0
echo
echo "Enter Boot ID of GRUB to delete (e.g. 0000):"
read -r BOOT_ID
sudo efibootmgr -b "$BOOT_ID" -B

echo "Conversion to systemd-boot complete."
echo
echo "=== Unpacking ==="
sleep 1.0
echo
mkdir /$HOME/.icons
mkdir /$HOME/.themes
cd /$HOME/.icons/
tar -xf /$HOME/.icons/BreezeX-RosePine-Linux.tar.xz
tar -xf /$HOME/.icons/Nordic-Folders.tar.xz
tar -xf /$HOME/.icons/rose-pine-hyprcursor.tar
cd /$HOME/.themes
tar -xf /$HOME/.themes/Tokyonight-Dark.tar.xz
cd
echo
echo "=== Cleaning Up ==="
sleep 1.0

mv /$HOME/.icons/BreezeX-RosePine-Linux ~/.icons/RosePine
sudo cp -r /$HOME/.icons/RosePine /usr/share/icons/
sudo cp -r /$HOME/.icons/rose-pine-hyprcursor /usr/share/icons/
sudo cp -r /$HOME/.icons/Nordic-Darker /usr/share/icons/
sudo rm -rf /$HOME/.icons/Nordic
sudo cp -r /$HOME/.themes/Tokyonight-Dark /usr/share/themes/
sudo cp /$HOME/Documents/wofissh.desktop /usr/share/applications/
sudo cp -r /$HOME/.root/.config /root/
sudo cp -r /$HOME/.root/.zshrc /root/
sudo cp -r /$HOME/.root/debianlogo.png /root/

echo "=== Setting up BTRFS ==="
sleep 1.0

echo "=== Unmounting /.snapshots if mounted ==="
sudo umount /.snapshots 2>/dev/null || echo "Already unmounted or not mounted."

echo "=== Deleting old /.snapshots directory ==="
sudo rm -rf /.snapshots

echo "=== Creating Snapper config for root ==="
sudo snapper -c root create-config /

echo "=== Deleting existing Btrfs subvolume at /.snapshots ==="
sudo btrfs subvolume delete /.snapshots 2>/dev/null || echo "No subvolume to delete."

echo "=== Recreating /.snapshots directory ==="
sudo mkdir /.snapshots

echo "=== Remounting all entries in /etc/fstab ==="
sudo mount -a

echo "=== Setting permissions and snapshot properties ==="
sudo chmod 750 /.snapshots
sudo btrfs property set -ts /.snapshots ro false

echo "=== Press Enter to edit Snapper Config ==="
read

echo "=== Opening Snapper config in Vim then install is complete ==="
sudo nvim /etc/snapper/configs/root

