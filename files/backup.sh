#!/bin/bash
# only if we're running the SQLite version
if [ "$GHOST_STORAGE" == "sqlite3" ]
then
    # compress the whole content directory and save it as a backup
    now="$(date +'%Y%m%d-%H%M%S')"
    echo "Storing Ghost backup for $now"
    tar -cvpzf $GHOST_BACKUP/backup-$now.tar.gz $GHOST_CONTENT
fi
