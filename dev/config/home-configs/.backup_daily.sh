#!/bin/bash
set -e

GDRIVE="$HOME/gdrive/backups/daily"
TMPDIR="/tmp/os-backup-daily"
DATE=$(date +%F)
TARFILE="os-backup-daily-$DATE.tar.gz"

# Embedded exclude list
EXCLUDES=(
    /proc /sys /dev /tmp /run /mnt /media /lost+found
    "$HOME/.cache" "$HOME/.local/share/Trash"
    /var/tmp /var/cache
)

mkdir -p "$GDRIVE" "$TMPDIR"
rm -rf "$TMPDIR/root" "$TMPDIR/user-config"

EXCLUDE_ARGS=()
for path in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(--exclude="$path")
done

rsync -aAXv / "$TMPDIR/root" "${EXCLUDE_ARGS[@]}"
rsync -a "$HOME/.config/" "$TMPDIR/user-config"

tar -czf "$GDRIVE/$TARFILE" -C "$TMPDIR" root user-config
rm -rf "$TMPDIR"

