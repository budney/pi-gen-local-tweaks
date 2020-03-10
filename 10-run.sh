#!/bin/bash -e

# Auto-upgrades configs
install -m 440 -o root -g root files/20auto-upgrades       "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
install -m 440 -o root -g root files/50unattended-upgrades "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
sed -i -e "s}SYSTEM_EMAIL_RECIPIENT}${SYSTEM_EMAIL_RECIPIENT}}" "${ROOTFS_DIR}/etc/apt/apt.conf.d/50unattended-upgrades"

# Samba credentials (needed by backup-manager)
mkdir "${ROOTFS_DIR}/etc/samba"
install -m 600 -o root -g root files/credentials "${ROOTFS_DIR}/etc/samba"
sed -i -e "s}SMB_USER}${SMB_USER}}" "${ROOTFS_DIR}/etc/samba/credentials"
sed -i -e "s}SMB_PASS}${SMB_PASS}}" "${ROOTFS_DIR}/etc/samba/credentials"

# Backup manager
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
