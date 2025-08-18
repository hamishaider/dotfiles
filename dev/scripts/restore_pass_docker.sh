#!/bin/bash

ARCHIVE_NAME="$HOME/dotfiles/dev/backups/pass-gpg-backup.tar.gz.gpg"
EXTRACT_DIR="$HOME/dotfiles/dev/backups/pass-gpg-restore"

echo "🔄 Restoring GPG keys and password-store from encrypted archive..."

if [ ! -f "$ARCHIVE_NAME" ]; then
  echo "Archive file not found: $ARCHIVE_NAME"
fi

# Clean previous extraction
rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

# Decrypt and extract
echo "Enter passphrase to decrypt the archive:"
gpg --pinentry-mode loopback --decrypt "$ARCHIVE_NAME" | tar xz -C "$EXTRACT_DIR" || {
  echo "Failed to decrypt and extract archive."
}

BACKUP_PATH="$EXTRACT_DIR/pass-gpg-backup"

# Import GPG keys
echo "Importing GPG keys..."
gpg --import "$BACKUP_PATH/public.gpg"
gpg --import "$BACKUP_PATH/private.gpg"

# Restore password store
echo "Restoring password-store..."
cp -r "$BACKUP_PATH/password-store" ~/.password-store

echo "Restore complete! Test with: pass ls"

