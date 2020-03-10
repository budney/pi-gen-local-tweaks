#!/bin/bash -e
# Install elasticsearch, if configured

if [ -z "$CONF_ELASTICSEARCH" ]; then
    exit 0
fi

# Step 1:
# Copy files and configs where we need them

install -m 644 -o root -g root files/elastic-7.x.list                   "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 644 -o root -g root files/elasticsearch-7.6.1-amd64.deb      "${ROOTFS_DIR}/tmp/"
install -m 644 -o root -g root files/elasticsearch.tgz                  "${ROOTFS_DIR}/tmp/"
install -m 644 -o root -g root files/elasticsearch                      "${ROOTFS_DIR}/tmp/"
install -m 644 -o root -g root files/elasticsearch.gpg                  "${ROOTFS_DIR}/tmp/"
install -m 644 -o root -g root files/jna-5.5.0.jar                      "${ROOTFS_DIR}/tmp/"

install -m 644 -o root -g root files/elasticsearch-classpath-patch.txt  "${ROOTFS_DIR}/tmp/"


# External SSD for elasticsearch data
cat files/fstab.elasticsearch >> "${ROOTFS_DIR}/etc/fstab"
mkdir -p /media/ssd

# Enable USB quirks for that specific SSD drive
sed -i -e 's/^/usb-storage.quirks=2109:3431:u /' "${ROOTFS_DIR}/boot/cmdline.txt"
