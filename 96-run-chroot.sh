#!/bin/bash -e
# Install "firstboot" script, if configured

if [ -z "$CONF_FIRSTBOOT" ]; then
    exit 0
fi

# Step 2:
# Enable the firstboot service.
systemctl enable firstboot

