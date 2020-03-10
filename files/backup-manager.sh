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

# That's it!
