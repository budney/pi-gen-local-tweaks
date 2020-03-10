#!/bin/bash -e
# Install djbdns and other DJB tools
# We do this last to avoid screwing up name resolution for the install

# Step 1:
# Copy source files where we need them

# ucspi-tcp
install -m 644 -o root -g root files/ucspi-tcp-0.88.tar.gz "${ROOTFS_DIR}/tmp/"
install -m 644 -o root -g root files/ucspi-tcp-0.88.errno.patch "${ROOTFS_DIR}/tmp/"

# daemontools
install -m 644 -o root -g root files/daemontools-0.76.tar.gz "${ROOTFS_DIR}/tmp/"
install -m 644 -o root -g root files/daemontools-0.76.errno.patch "${ROOTFS_DIR}/tmp/"

# djbdns
install -m 644 -o root -g root files/djbdns-1.05.tar.gz "${ROOTFS_DIR}/tmp/"

# systemctl config file
install -m 644 -o root -g root files/daemontools.service "${ROOTFS_DIR}/lib/systemd/system/"

# Disable WiFi and bluetooth
cat >> "${ROOTFS_DIR}/boot/config.txt" <<EOF

# wifi off
dtoverlay=pi3-disable-wifi
# bluetooth off
dtoverlay=pi3-disable-bt
EOF

