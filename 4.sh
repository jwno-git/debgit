#!/bin/bash

set -e

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
