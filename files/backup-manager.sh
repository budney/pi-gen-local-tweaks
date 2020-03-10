#!/bin/sh

# Cron script for backup-manager

# Set paths
BACKUP=/var/share/backup
TMPDIR=$BACKUP/.tmp; export TMPDIR

# Don't run if the programs aren't installed
test -x /usr/sbin/backup-manager        || exit 0
test -x /usr/local/bin/dropbox_uploader || exit 0

# Don't run if the backup volume isn't mounted
test -e /var/share/backup/.mounted || exit 0

# Generate the backup
/usr/sbin/backup-manager || exit $?

# Then, upload it to dropbox
dropbox_uploader -s \
    -f /etc/dropbox_uploader \
    upload \
    $BACKUP/* Apps/backup-manager/

# Delete things that have been purged locally
dropbox_uploader list /Apps/backup-manager \
    | egrep '\[F\]' \
    | awk '{$1=""; $2=""; print}' \
    | while read f; \
        do test -f "$BACKUP/$f" \
        || dropbox_uploader delete "/Apps/backup-manager/$f"; \
    done

# That's it!
