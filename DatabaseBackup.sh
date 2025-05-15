#!/bin/bash

docker exec CE-Boostup-XIII-Database bash -c "pg_dump -U yeah -C -f /opt/backup/backup-$(date +%d.%m.%Y-%H:%M%:z).dump -Fc ce-boostup"
find "/home/CE-Boostup-XIII/..." -type f -mtime +7 -exec rm {} \;
