#!/bin/bash

set -e

echo "!!! Begin Install !!!"
echo
read
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
  firefox-esr-l10n-en-ca \
  flatpak \
  fonts-font-awesome \
  fonts-terminus \
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
  wf-recorder \
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

echo "=== Adding Flathub and installing Flatpaks ==="
echo

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo

sudo flatpak install -y flathub \
	com.obsproject.Studio \
	org.kde.kdenlive \
	org.libreoffice.LibreOffice \
	org.gnome.eog \
	com.bitwarden.desktop \
	org.gimp.GIMP \
	io.mpv.Mpv \
	org.gnome.Calculator \
	org.standardnotes.standardnotes

echo "=== Creating Flatpak menu entries ==="

sudo ln -s /var/lib/flatpak/exports/share/applications/org.kde.kdenlive.desktop /usr/share/applications/org.kde.kdenlive.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/com.obsproject.Studio.desktop /usr/share/applications/com.obsproject.Studio.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/org.libreoffice.Libreoffice.calc.desktop /usr/share/applications/org.libreoffice.Libreoffice.calc.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/org.libreoffice.Libreoffice.writer.desktop /usr/share/applications/org.libreoffice.Libreoffice.writer.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gnome.eog.desktop /usr/share/applications/org.gnome.eog.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/com.bitwarden.desktop.desktop /usr/share/applications/com.bitwarden.desktop.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gimp.GIMP.desktop /usr/share/applications/org.gimp.GIMP.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/io.mpv.Mpv.desktop /usr/share/applications/io.mpv.Mpv.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gnome.Calculator.desktop /usr/share/applications/org.gnome.Calculator.desktop
sudo ln -s /var/lib/flatpak/exports/share/applications/org.standardnotes.standardnotes.desktop /usr/share/applications/org.standardnotes.standardnotes.desktop

echo "=== Setting global Flatpak overrides ==="
sleep 0.5

sudo flatpak override \
	--filesystem=/home/$USER/.themes \
	--filesystem=/home/$USER/.icons \
 	--filesystem=xdg-config/gtk-3.0 \
	--filesystem=xdg-config/gtk-4.0 \
	--env=GTK_THEME=Tokyonight-Dark \
	--env=XCURSOR_THEME=RosePine \
	--env=XCURSOR_SIZE=32 \
	--socket=wayland \
        --talk-name=org.freedesktop.portal.Desktop

echo "=== Setting individual overrides ==="
sleep 0.5

sudo flatpak override com.obsproject.Studio \
	--filesystem=home \
	--filesystem=xdg-run/pipewire-0 \
  	--env=QT_QPA_PLATFORM=wayland

sudo flatpak override org.kde.kdenlive \
  	--filesystem=home \
  	--env=QT_QPA_PLATFORM=wayland

sudo flatpak override org.gnome.eog \
  	--filesystem=home

sudo flatpak override io.mpv.Mpv \
	--filesystem=home

sudo flatpak override net.cozic.joplin_desktop \
	--filesystem=home

sudo flatpak override org.libreoffice.Libreoffice \
	--filesystem=home

sudo flatpak override org.gimp.GIMP \
	--filesystem=home

echo "=== Building Hypr Packages ==="
sleep 1.0
echo
mkdir -p /home/$USER/.src
git clone https://github.com/zsh-users/zsh-completions /home/$USER/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting /home/$USER/.zsh/zsh-syntax-highlighting
git clone https://github.com/hyprwm/hyprutils /home/$USER/.src/hyprutils
git clone https://github.com/hyprwm/hyprlang /home/$USER/.src/hyprlang
git clone https://github.com/hyprwm/hyprwayland-scanner /home/$USER/.src/hyprwayland-scanner
git clone https://github.com/hyprwm/hyprgraphics /home/$USER/.src/hyprgraphics
git clone https://github.com/hyprwm/hyprlock /home/$USER/.src/hyprlock
git clone https://github.com/hyprwm/hyprpaper /home/$USER/.src/hyprpaper
git clone https://github.com/hyprwm/hyprpicker /home/$USER/.src/hyprpicker

sleep 0.5
echo "Hyprutils"
cd /home/$USER/.src/hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprlang"
cd /home/$USER/.src/hyprlang/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

sleep 0.5
echo "Hyprwayland-Scanner"
cd /home/$USER/.src/hyprwayland-scanner/
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprgraphics"
cd /home/$USER/.src/hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprlock"
cd /home/$USER/.src/hyprlock/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
echo

sleep 0.5
echo "Hyprpaper"
cd /home/$USER/.src/hyprpaper/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

sleep 0.5
echo "Hyprpicker"
cd /home/$USER/.src/hyprpicker/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpicker -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
echo

cd

echo "  !!! Packages installed and overrides applied !!!  "
echo "Now to install Systemd Boot Loader and Uninstall Grub"

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
  vim-tiny \
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
cd /home/$USER/.icons/
tar -xf /home/$USER/.icons/BreezeX-RosePine-Linux.tar.xz
tar -xf /home/$USER/.icons/Nordic-Folders.tar.xz
tar -xf /home/$USER/.icons/rose-pine-hyprcursor.tar
cd /home/$USER/.themes
tar -xf /home/$USER/.themes/Tokyonight-Dark.tar.xz
cd
echo
echo "=== Cleaning Up ==="
sleep 1.0

mv /home/$USER/.icons/BreezeX-RosePine-Linux ~/.icons/RosePine
sudo cp -r /home/$USER/.icons/RosePine /usr/share/icons/
sudo cp -r /home/$USER/.icons/rose-pine-hyprcursor /usr/share/icons/
sudo cp -r /home/$USER/.icons/Nordic-Darker /usr/share/icons/
sudo rm -rf /home/$USER/.icons/Nordic
sudo cp -r /home/$USER/.themes/Tokyonight-Dark /usr/share/themes/
sudo cp -r /home/$USER/.root/.config /root/
sudo cp -r /home/$USER/.root/.zshrc /root/
sudo cp -r /home/$USER/.root/.vimrc /root/
sudo cp -r /home/$USER/.zsh /root/
sudo cp -r /home/$USER/.root/debianlogo.png /root/
sudo chmod +x /home/$USER/.local/scripts/toggle_record.sh
sudo chmod +x /home/$USER/.local/scripts/toggle_notes.sh
sudo chmod +x /home/$USER/.local/scripts/toggle_term.sh
sudo chmod +x /home/$USER/.local/scripts/help_desk.sh
sudo chmod +x /home/$USER/.local/scripts/vim-term.sh
sudo chmod +x /home/$USER/.local/scripts/volume-notify.sh
sudo chmod +x /home/$USER/.local/scripts/wofi-ssh.sh

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

echo "=== Configuring Snapper Settings ==="
# Backup original config
sudo cp /etc/snapper/configs/root /etc/snapper/configs/root.backup

# Apply your custom configuration
sudo sed -i 's/^TIMELINE_CREATE=.*/TIMELINE_CREATE="yes"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_CLEANUP=.*/TIMELINE_CLEANUP="yes"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_MIN_AGE=.*/TIMELINE_MIN_AGE="1800"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_HOURLY=.*/TIMELINE_LIMIT_HOURLY="8"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_DAILY=.*/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_WEEKLY=.*/TIMELINE_LIMIT_WEEKLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_MONTHLY=.*/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_YEARLY=.*/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/^NUMBER_CLEANUP=.*/NUMBER_CLEANUP="yes"/' /etc/snapper/configs/root
sudo sed -i 's/^NUMBER_MIN_AGE=.*/NUMBER_MIN_AGE="1800"/' /etc/snapper/configs/root
sudo sed -i 's/^NUMBER_LIMIT=.*/NUMBER_LIMIT="10"/' /etc/snapper/configs/root
sudo sed -i 's/^NUMBER_LIMIT_IMPORTANT=.*/NUMBER_LIMIT_IMPORTANT="5"/' /etc/snapper/configs/root

echo "=== Creating boot snapshot service ==="
# Create in user's local scripts directory
tee ~/.local/scripts/snapper-daily-check.sh > /dev/null << 'EOF'
#!/bin/bash
CONFIG="root"
TODAY=$(date +%Y-%m-%d)

# Check if we already have a snapshot from today
EXISTING=$(sudo snapper -c "$CONFIG" list -t single | grep "$TODAY" | grep -c "boot-$TODAY")

if [ "$EXISTING" -eq 0 ]; then
    echo "Taking daily snapshot for $TODAY"
    sudo snapper -c "$CONFIG" create --type single --description "boot-$TODAY-$(date +%H:%M)"
    sudo snapper -c "$CONFIG" cleanup timeline
else
    echo "Daily snapshot for $TODAY already exists, skipping"
fi
EOF

chmod +x ~/.local/scripts/snapper-daily-check.sh

# Create symlink so systemd can find it
sudo ln -sf "/home/$USER/.local/scripts/snapper-daily-check.sh" /usr/local/bin/snapper-daily-check.sh

echo "=== Creating systemd service for boot snapshots ==="
sudo tee /etc/systemd/system/snapper-boot.service > /dev/null << 'EOF'
[Unit]
Description=Take daily snapper snapshot on boot (if needed)
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/snapper-daily-check.sh

[Install]
WantedBy=multi-user.target
EOF

echo "=== Configuring cleanup timer ==="
sudo mkdir -p /etc/systemd/system/snapper-cleanup.timer.d
sudo tee /etc/systemd/system/snapper-cleanup.timer.d/override.conf > /dev/null << 'EOF'
[Timer]
# Clear the original timer settings
OnCalendar=
OnUnitActiveSec=

# Run cleanup on boot and every 6 hours
OnBootSec=30min
OnUnitActiveSec=6h
Persistent=true
EOF

echo "=== Enabling services ==="
sudo systemctl daemon-reload
sudo systemctl enable snapper-boot.service
sudo systemctl enable snapper-cleanup.timer

echo "=== Snapper configuration complete! ==="
