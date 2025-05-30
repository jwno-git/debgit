#!/bin/bash
TERMINAL_BIN="terminator"
SPECIAL="special:terminal"
CLASS_NAME="terminator"

# Programs to exclude (terminals running these won't be hidden)
EXCLUDE_PROGRAMS=("btop" "htop" "lf" "ranger" "vim" "nvim" "nano" "less" "more" "man")

# Function to get process tree for a window
get_window_processes() {
    local window_pid=$1
    # Get all child processes recursively
    pstree -p "$window_pid" 2>/dev/null | grep -oP '\(\K\d+(?=\))' | while read pid; do
        ps -p "$pid" -o comm= 2>/dev/null
    done
}

# Function to check if terminal is running excluded programs
is_terminal_busy() {
    local window_pid=$1
    local processes
    processes=$(get_window_processes "$window_pid")
    
    for exclude in "${EXCLUDE_PROGRAMS[@]}"; do
        if echo "$processes" | grep -q "^$exclude$"; then
            return 0  # Terminal is busy
        fi
    done
    return 1  # Terminal is free
}

# Get all terminator clients
CLIENTS=$(hyprctl clients -j | jq -r --arg class "$CLASS_NAME" '.[] | select(.initialClass == $class)')

# If no terminals running, launch one
if [[ -z "$CLIENTS" ]]; then
    $TERMINAL_BIN &
    
    # Wait for window to appear
    for i in {1..30}; do
        sleep 0.1
        CLIENTS=$(hyprctl clients -j | jq -r --arg class "$CLASS_NAME" '.[] | select(.initialClass == $class)')
        [[ -n "$CLIENTS" ]] && break
    done
    exit 0
fi

# Find the first "free" terminal (not running excluded programs)
TARGET_CLIENT=""
while IFS= read -r client; do
    [[ -z "$client" ]] && continue
    
    PID=$(echo "$client" | jq -r '.pid')
    ADDRESS=$(echo "$client" | jq -r '.address')
    
    if ! is_terminal_busy "$PID"; then
        TARGET_CLIENT="$client"
        break
    fi
done <<< "$(echo "$CLIENTS" | jq -c '.')"

# If no free terminal found, create a new one
if [[ -z "$TARGET_CLIENT" ]]; then
    $TERMINAL_BIN &
    exit 0
fi

# Get details of target terminal
ADDRESS=$(echo "$TARGET_CLIENT" | jq -r '.address')
WORKSPACE=$(echo "$TARGET_CLIENT" | jq -r '.workspace.name')
ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.name')

# Move to or from special workspace
if [[ "$WORKSPACE" == "$SPECIAL" ]]; then
    hyprctl dispatch movetoworkspace "$ACTIVE_WS,address:$ADDRESS"
    hyprctl dispatch focuswindow "address:$ADDRESS"
else
    hyprctl dispatch movetoworkspacesilent "$SPECIAL,address:$ADDRESS"
fi
