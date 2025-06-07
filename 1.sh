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

sudo apt update
sudo apt modernize-sources -y
