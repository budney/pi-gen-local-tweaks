#!/bin/bash -e

# Network config
install -m 644 -o root -g root files/eth0 "${ROOTFS_DIR}/etc/network/interfaces.d/"
sed -i -e "s}HOST_IP}${HOST_IP}}" "${ROOTFS_DIR}/etc/network/interfaces.d/eth0"
sed -i -e "s}NET_GATEWAY}${NET_GATEWAY}}" "${ROOTFS_DIR}/etc/network/interfaces.d/eth0"

# DNS Config: uncomment the name_servers line in resolvconf.conf
sed -i -e '/name_servers=/s/^#//' "${ROOTFS_DIR}/etc/resolvconf.conf"

# Remove the no-longer-needed line from /etc/hosts
sed -i -e "/${TARGET_HOSTNAME}/d" "${ROOTFS_DIR}/etc/hosts"
