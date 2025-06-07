#!/bin/bash

TERMINAL_BIN="flatpak run org.standardnotes.standardnotes"
SCRATCHPAD_MARK="standardnotes"
CLASS_NAME="Standard Notes"

# Get window info using swaymsg
WINDOW_INFO=$(swaymsg -t get_tree | jq -r --arg class "$CLASS_NAME" '
   .. | objects | select(.app_id == $class or .window_properties.class == $class) | 
   {id: .id, workspace: (.workspace // "unknown"), marks: .marks}
')

# If not running, launch and wait
if [[ -z "$WINDOW_INFO" || "$WINDOW_INFO" == "null" ]]; then
   $TERMINAL_BIN &
   
   # Wait for window to appear
   for i in {1..30}; do
       sleep 0.1
       WINDOW_INFO=$(swaymsg -t get_tree | jq -r --arg class "$CLASS_NAME" '
           .. | objects | select(.app_id == $class or .window_properties.class == $class) | 
           {id: .id, workspace: (.workspace // "unknown"), marks: .marks}
       ')
       [[ -n "$WINDOW_INFO" && "$WINDOW_INFO" != "null" ]] && break
   done

   # Exit here so it stays on screen after launching
   exit 0
fi

# Get window ID
WINDOW_ID=$(echo "$WINDOW_INFO" | jq -r '.id')
HAS_MARK=$(echo "$WINDOW_INFO" | jq -r --arg mark "$SCRATCHPAD_MARK" '.marks | contains([$mark])')

# Toggle between scratchpad and workspace
if [[ "$HAS_MARK" == "true" ]]; then
   # Window is in scratchpad, bring it to current workspace
   swaymsg "[con_id=$WINDOW_ID] move to workspace current, floating disable, unmark $SCRATCHPAD_MARK, focus"
else
   # Window is visible, move to scratchpad
   swaymsg "[con_id=$WINDOW_ID] mark $SCRATCHPAD_MARK, move scratchpad"
fi
