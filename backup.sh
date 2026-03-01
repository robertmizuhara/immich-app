#!/bin/sh
set -e

REPO_URL="${RESTIC_REPO#rest:}"
REPO_HOST=$(echo "$REPO_URL" | sed -n 's|.*@\([^:]*\):\([0-9]*\)/.*|\1:\2|p')

echo "Starting backup service..."

echo "Waiting 3 seconds for services to initialize..."
sleep 3

while true; do
  echo "Checking connectivity to ${REPO_HOST}..."
  if curl -s --connect-timeout 5 --max-time 10 "http://${REPO_HOST}" > /dev/null 2>&1; then
    echo "Server reachable, initializing repository..."
    restic init --repo ${RESTIC_REPO} || true
    echo "Server reachable, attempting backup..."
    if restic backup /data /postgres --repo ${RESTIC_REPO} --host immich; then
      echo "Backup completed successfully"
    else
      echo "Backup failed (remote unreachable?)"
    fi
  else
    echo "Server unreachable, skipping backup..."
  fi
  echo "Current sync: $(date '+%Y-%m-%d %H:%M:%S')"
  NEXT=$(( $(date +%s) + BACKUP_INTERVAL_MINUTES * 60 ))
  echo "Next sync: $(date -d @${NEXT} '+%Y-%m-%d %H:%M:%S')"
  echo "Waiting ${BACKUP_INTERVAL_MINUTES} minutes..."
  sleep $((BACKUP_INTERVAL_MINUTES * 60))
done
