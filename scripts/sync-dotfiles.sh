#!/usr/bin/env bash

set -euo pipefail

# Absolute path to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Repo root is parent of scripts/
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source directories in repo
CONFIG_SRC="$REPO_ROOT/dev/config"
DOTFILES_SRC="$REPO_ROOT/dev/dotfiles"
BIN_SRC="$REPO_ROOT/dev/bin"

# Destination directories
CONFIG_DST="$HOME/.config"
DOTFILES_DST="$HOME"
BIN_DST="$HOME/.local/bin"

# Config folders to sync WITH delete (allowlist)
CONFIG_FOLDERS=(
    nvim
    alacritty
    hypr
    tmux
    ghostty
    rofi
    waybar
)

# Rsync flags
RSYNC_FLAGS=(-avh --progress)

# Dry-run support
if [[ "${1:-}" == "--dry-run" ]]; then
    echo "Dry run enabled"
    RSYNC_FLAGS+=(--dry-run)
fi

echo "Syncing ~/.config (restricted folders only)"

for folder in "${CONFIG_FOLDERS[@]}"; do
    SRC="$CONFIG_SRC/$folder"
    DST="$CONFIG_DST/$folder"

    if [[ ! -d "$SRC" ]]; then
        echo "Warning: $SRC does not exist, skipping"
        continue
    fi

    mkdir -p "$DST"

    echo "→ Syncing $folder with --delete"
    rsync "${RSYNC_FLAGS[@]}" --delete "$SRC/" "$DST/"
done

echo "Syncing home dotfiles"
rsync "${RSYNC_FLAGS[@]}" \
    "$DOTFILES_SRC/.zshrc" \
    "$DOTFILES_SRC/.p10k.zsh" \
    "$DOTFILES_DST/"

echo "Syncing ~/.local/bin"
mkdir -p "$BIN_DST"
rsync "${RSYNC_FLAGS[@]}" "$BIN_SRC/" "$BIN_DST/"

echo "Dotfiles and binaries synced"

chmod -R u+x "$BIN_DST"
echo "Binaries made executable"

