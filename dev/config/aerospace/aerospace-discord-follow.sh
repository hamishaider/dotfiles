#!/usr/bin/env bash

TARGET_TITLE="Discord | Lounge"

# Get the ID of the Discord window with exact title
WINDOW_ID=$(aerospace list-windows --all \
  | awk -F'|' -v title="$TARGET_TITLE" '
    $3 ~ title { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); print $1 }
  ')

# Exit if not found
[ -z "$WINDOW_ID" ] && exit 0

# Get current focused workspace
CURRENT_WS=$(aerospace list-workspaces --focused)

# Move the window to the current workspace
aerospace move-node-to-workspace --window-id "$WINDOW_ID" "$CURRENT_WS"
