#!/bin/bash

# --------------------------------------------
# backup-data.sh
# Creates a timestamped backup of ./data/
# Excludes README.md
# --------------------------------------------

set -e

BACKUP_DIR="./backups"
DATA_DIR="./data"
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
BACKUP_NAME="ha-docker-backup-$TIMESTAMP.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "🔄 Creating backup..."
tar --exclude="$DATA_DIR/README.md" \
    -czf "$BACKUP_PATH" \
    -C "$DATA_DIR" .

echo "✅ Backup created at: $BACKUP_PATH"
