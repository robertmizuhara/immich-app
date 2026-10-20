#!/bin/sh
set -e

echo "Starting backup..."
restic init --repo ${RESTIC_REPO} || true
if restic backup /data /postgres --repo ${RESTIC_REPO} --host immich; then
  BACKUP_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "Backup completed successfully at ${BACKUP_TIME}"
  echo "${BACKUP_TIME}" > /data/backup_state.txt
else
  echo "Backup failed"
  exit 1
fi
