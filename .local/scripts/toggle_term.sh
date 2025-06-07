#!/bin/bash

TERMINAL_BIN="foot"
SCRATCHPAD_MARK="terminal"
CLASS_NAME="foot"

# Get all foot windows using swaymsg
WINDOWS_INFO=$(swaymsg -t get_tree | jq -r --arg class "$CLASS_NAME" '
    [.. | objects | select(.app_id == $class) | 
    {id: .id, workspace: (.workspace // "unknown"), marks: .marks}]
')

# If no terminals running, launch one
if [[ "$WINDOWS_INFO" == "[]" || -z "$WINDOWS_INFO" ]]; then
    $TERMINAL_BIN &
    
    # Wait for window to appear
    for i in {1..30}; do
        sleep 0.1
        WINDOWS_INFO=$(swaymsg -t get_tree | jq -r --arg class "$CLASS_NAME" '
            [.. | objects | select(.app_id == $class) | 
            {id: .id, workspace: (.workspace // "unknown"), marks: .marks}]
        ')
        [[ "$WINDOWS_INFO" != "[]" && -n "$WINDOWS_INFO" ]] && break
    done
    exit 0
fi

# Check if any terminal is in scratchpad (has our mark)
SCRATCHPAD_WINDOW=$(echo "$WINDOWS_INFO" | jq -r --arg mark "$SCRATCHPAD_MARK" '
    .[] | select(.marks | contains([$mark])) | .id
')

if [[ -n "$SCRATCHPAD_WINDOW" && "$SCRATCHPAD_WINDOW" != "null" ]]; then
    # Found terminal in scratchpad, bring it back
    swaymsg "[con_id=$SCRATCHPAD_WINDOW] move to workspace current"
    swaymsg "[con_id=$SCRATCHPAD_WINDOW] unmark $SCRATCHPAD_MARK"
    swaymsg "[con_id=$SCRATCHPAD_WINDOW] focus"
else
    # No terminals in scratchpad, hide the first visible one
    VISIBLE_WINDOW=$(echo "$WINDOWS_INFO" | jq -r --arg mark "$SCRATCHPAD_MARK" '
        .[] | select(.marks | contains([$mark]) | not) | .id
    ' | head -n1)
    
    if [[ -n "$VISIBLE_WINDOW" && "$VISIBLE_WINDOW" != "null" ]]; then
        # Hide this terminal in scratchpad
        swaymsg "[con_id=$VISIBLE_WINDOW] mark $SCRATCHPAD_MARK"
        swaymsg "[con_id=$VISIBLE_WINDOW] move scratchpad"
    fi
fi
