#!/bin/bash -e
# Install sSMTP for lightweight email

if [ -z "$CONF_SSMTP" ]; then
    exit 0
fi

# Install mail agents, whose packages are poorly behaved.
# (Install fails if we don't have a FQDN as our hostname.)
hostname ${TARGET_HOSTNAME}
apt-get install -y ssmtp mailutils
apt-get install -y bsd-mailx

