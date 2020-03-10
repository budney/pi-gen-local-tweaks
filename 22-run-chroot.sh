#!/bin/bash -e
# Install sSMTP for lightweight email

if [ -z "$CONF_SSMTP" ]; then
    exit 0
fi

# Create an ssmtp group
if ! egrep -q ssmtp /etc/group >/dev/null 2>&1; then
    groupadd ssmtp
    usermod -a -G ssmtp root
    usermod -a -G ssmtp ${FIRST_USER_NAME}
    chown -R root:ssmtp /etc/ssmtp
fi

