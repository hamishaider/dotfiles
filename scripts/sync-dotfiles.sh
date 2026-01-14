#!/usr/bin/env bash

set -e
set -u

# Get absolute path to repo root (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR/dev/config"
TARGET_DIR="$HOME/.config"

# Dry-run option
if [[ "${1:-}" == "--dry-run" ]]; then
    echo "🧪 Dry run: syncing $REPO_DIR → $TARGET_DIR"
    rsync -avh --dry-run --progress "$REPO_DIR/" "$TARGET_DIR/"
    exit 0
fi

# Sync operation
echo "syncing $REPO_DIR to $TARGET_DIR..."
rsync -avh --progress "$REPO_DIR/" "$TARGET_DIR/"

echo "Dotfiles synced to ~/.config"
