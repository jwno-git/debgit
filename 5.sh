#!/bin/bash

set -e

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
