#!/bin/bash -e
# Install sSMTP for lightweight email

if [ -z "$CONF_SSMTP" ]; then
    exit 0
fi

# SSMTP config for emails in Len's name
install -m 440 -o root -g root files/ssmtp.conf "${ROOTFS_DIR}/etc/ssmtp/"
install -m 440 -o root -g root files/revaliases "${ROOTFS_DIR}/etc/ssmtp/"

# SSMTP configs
for file in ssmtp.conf revaliases; do
    install -m 440 -o root -g root files/${file} "${ROOTFS_DIR}/etc/ssmtp/"
    sed -i -e "s/SSMTP_USER/${SSMTP_USER}" "${ROOTFS_DIR}/etc/ssmtp/${file}"
    sed -i -e "s/SSMTP_PASS/${SSMTP_PASS}" "${ROOTFS_DIR}/etc/ssmtp/${file}"
    sed -i -e "s/FIRST_USER_NAME/${FIRST_USER_NAME}" "${ROOTFS_DIR}/etc/ssmtp/${file}"
    sed -i -e "s/SSMTP_ROOT_ALIAS/${SSMTP_ROOT_ALIAS}" "${ROOTFS_DIR}/etc/ssmtp/${file}"
done

