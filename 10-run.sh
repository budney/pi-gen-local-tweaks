#!/bin/bash -e

# SSMTP config for emails in Len's name
install -m 440 -o root -g root files/ssmtp.conf "${ROOTFS_DIR}/etc/ssmtp/"
install -m 440 -o root -g root files/revaliases "${ROOTFS_DIR}/etc/ssmtp/"

# Auto-upgrades configs
install -m 440 -o root -g root files/20auto-upgrades       "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
install -m 440 -o root -g root files/50unattended-upgrades "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
sed -i -e "s}SYSTEM_EMAIL_RECIPIENT}${SYSTEM_EMAIL_RECIPIENT}}" "${ROOTFS_DIR}/etc/apt/apt.conf.d/50unattended-upgrades"

# Backup manager
install -m 400 -o root -g root files/backup-manager.conf "${ROOTFS_DIR}/etc/"
sed -i -e "s}SYSTEM_EMAIL_RECIPIENT}${SYSTEM_EMAIL_RECIPIENT}}" "${ROOTFS_DIR}/etc/backup-manager.conf"
cat files/fstab.backup >> "${ROOTFS_DIR}/etc/fstab"
mkdir -p "${ROOTFS_DIR}/var/share/backup"

# Dropbox uploader
install -m 750 -o root -g root files/dropbox_uploader.sh "${ROOTFS_DIR}/usr/local/bin/dropbox_uploader"
echo "OAUTH_ACCESS_TOKEN=${OAUTH_ACCESS_TOKEN}" > "${ROOTFS_DIR}/etc/dropbox_uploader/dropbox_uploader.conf"

# Metricbeat
gunzip -c files/metricbeat.tgz | ( cd "${ROOTFS_DIR}"; tar xf -; )

# Install ${FIRST_USER_NAME} as a sudoer, and delete all passwordless sudoers
rm -f "${ROOTFS_DIR}/etc/sudoers.d/*-nopasswd"
install -m 440 -o root -g root files/sudoers "${ROOTFS_DIR}/etc/sudoers.d/010_${FIRST_USER_NAME}"
sed -i -e "s}USER}${FIRST_USER_NAME}}" "${ROOTFS_DIR}/etc/sudoers.d/010_${FIRST_USER_NAME}"

# Install some ssh files
mkdir -m 03700 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh"
install -m 600 files/authorized_keys "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh/"
