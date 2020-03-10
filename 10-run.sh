#!/bin/bash -e

# Auto-upgrades configs
install -m 440 -o root -g root files/20auto-upgrades       "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
install -m 440 -o root -g root files/50unattended-upgrades "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
sed -i -e "s}SYSTEM_EMAIL_RECIPIENT}${SYSTEM_EMAIL_RECIPIENT}}" "${ROOTFS_DIR}/etc/apt/apt.conf.d/50unattended-upgrades"

# Dropbox uploader
install -m 700 -o root -g root files/dropbox_uploader.sh "${ROOTFS_DIR}/usr/local/bin/dropbox_uploader"
echo "OAUTH_ACCESS_TOKEN=${OAUTH_ACCESS_TOKEN}" > "${ROOTFS_DIR}/etc/dropbox_uploader"
chmod 0400 "${ROOTFS_DIR}/etc/dropbox_uploader"

# Backup manager (depends on dropbox uploader)
install -m 400 -o root -g root files/backup-manager.sh   "${ROOTFS_DIR}/etc/cron.daily/backup-manager"
install -m 400 -o root -g root files/backup-manager.conf "${ROOTFS_DIR}/etc/backup-manager"
sed -i -e "s}SYSTEM_EMAIL_RECIPIENT}${SYSTEM_EMAIL_RECIPIENT}}" "${ROOTFS_DIR}/etc/backup-manager.conf"
cat files/fstab.backup >> "${ROOTFS_DIR}/etc/fstab"
mkdir -p "${ROOTFS_DIR}/var/share/backup"

# GPG Public Key (needed by backup-manager; must match ${SYSTEM_EMAIL_RECIPIENT})
install -m 0400 -o root -g root files/pubkey.gpg "${ROOTFS_DIR}/tmp"

# Metricbeat
gunzip -c files/metricbeat.tgz | ( cd "${ROOTFS_DIR}"; tar xf -; )

# Install ${FIRST_USER_NAME} as a sudoer, and delete all passwordless sudoers
rm -f "${ROOTFS_DIR}/etc/sudoers.d/*-nopasswd"
install -m 440 -o root -g root files/sudoers "${ROOTFS_DIR}/etc/sudoers.d/010_${FIRST_USER_NAME}"
sed -i -e "s}USER}${FIRST_USER_NAME}}" "${ROOTFS_DIR}/etc/sudoers.d/010_${FIRST_USER_NAME}"

# Install some ssh files
mkdir -m 03700 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh"
install -m 600 files/authorized_keys "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh/"
