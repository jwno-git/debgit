#!/bin/bash

# Change the volume
wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"

# Get the new volume
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f%%", $2 * 100}')

# Send a notification using notify-send (works with mako)
# Use app-name volume to trigger mako's special volume styling
notify-send -a volume -h int:value:${VOLUME%\%} "Volume: $VOLUME"
