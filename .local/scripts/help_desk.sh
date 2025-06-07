#!/bin/bash
# Show main help topic list (uses your default wofi config for size and position)
CHOICE=$(wofi --dmenu < ~/.config/help_desk/help_desk_list)
if [ -n "$CHOICE" ]; then
    FILE_NAME="${CHOICE,,}_list"
    FILE_PATH="$HOME/.config/help_desk/$FILE_NAME"
    if [ -f "$FILE_PATH" ]; then
        # Read and format the file content
        CONTENT=$(cat "$FILE_PATH" | \
            sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | \
            sed 's/\*\*\([^*]*\)\*\*/<b><span foreground="#A3A3A3">\1<\/span><\/b>/g' | \
            sed 's/^• /<span foreground="#214351">• <\/span>/' | \
            sed 's/^\(<span[^>]*>• <\/span>\)\(.*\)/\1<span foreground="#214351">\2<\/span>/')
        
        # Send notification with 30 second timeout using notify-send (works with mako)
        dunstify -t 30000 "$CHOICE Commands" "$CONTENT"
    fi
fi
