#!/bin/sh
printf 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nBackup triggered\n'
nohup docker compose -f /home/robert/Documents/Projects/immich-app/docker-compose.yml run --rm backup > /tmp/backup.log 2>&1 &
