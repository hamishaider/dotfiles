#!/bin/bash

BACKUP_DIR=$HOME/dotfiles/dev/backups/pass-gpg-backup
ARCHIVE_NAME=$HOME/dotfiles/dev/backups/pass-gpg-backup.tar.gz.gpg

mkdir -p "$BACKUP_DIR"

echo "Backing up GPG and pass data..."

# Clean up any previous backup
rm -rf "$BACKUP_DIR" "$ARCHIVE_NAME"

mkdir "$BACKUP_DIR"

# Export GPG public and private keys (change YOUR_KEY_ID if needed)
KEY_ID=$(gpg --list-secret-keys --with-colons "orb-docker" | grep '^sec' | head -n1 | cut -d: -f5)

echo "Using GPG Key ID: $KEY_ID"

gpg --export -a "$KEY_ID" > "$BACKUP_DIR/public.gpg"
gpg --export-secret-keys -a "$KEY_ID" > "$BACKUP_DIR/private.gpg"

# Copy password store
cp -r ~/.password-store "$BACKUP_DIR/password-store"

# Create encrypted archive
echo "Enter passphrase to encrypt the archive:"
tar czf - "$BACKUP_DIR" | gpg --pinentry-mode loopback --symmetric --cipher-algo AES256 -o "$ARCHIVE_NAME"

echo "Backup complete: $ARCHIVE_NAME"
echo "Removing the backup dir: $BACKUP_DIR"
rm -r $BACKUP_DIR

