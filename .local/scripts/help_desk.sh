#!/bin/bash

# Show main help topic list (uses your default wofi config for size and position)
CHOICE=$(wofi --dmenu < ~/.config/help_desk/help_desk_list)

if [ -n "$CHOICE" ]; then
    FILE_NAME="${CHOICE,,}_list"
    FILE_PATH="$HOME/.config/help_desk/$FILE_NAME"

    if [ -f "$FILE_PATH" ]; then
        # Show submenu (overrides config: 30% width, centred horizontally)
        wofi --dmenu --width 25% -x 1075 -y 5 < "$FILE_PATH"
    fi
fi

