#!/bin/bash

set -e

sleep 1.0

sudo apt install -y \
  bluez \
  brave-browser \
  brightnessctl \
  btop \
  chafa \
  cliphist \
  fastfetch \
  fbset \
  firefox-esr-l10n-en-ca \
  flatpak \
  fonts-font-awesome \
  fonts-terminus \
  gimp \
  grim \
  imagemagick \
  jq \
  lf \
  lxpolkit \
  mako-notifier \
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
  sway \
  swaybg \
  swappy \
  tar \
  vim \
  waybar \
  wireplumber \
  wf-recorder \
  wget \
  wlogout \
  wofi \
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
