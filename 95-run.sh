#!/bin/bash -e
# Install "firstboot" script, if configured

if [ -z "$CONF_FIRSTBOOT" ]; then
    exit 0
fi

# Step 1:
# Copy files and configs where we need them
install -m 644 -o root -g root files/firstboot.service "${ROOTFS_DIR}/lib/systemd/system/"
install -m 755 -o root -g root files/firstboot.sh      "${ROOTFS_DIR}/etc/"
install -m 644 -o root -g root files/firstboot.config  "${ROOTFS_DIR}/boot/"

# Step 2:
# Load the configfile defaults into firstboot.config
for field in TARGET_HOSTNAME HOST_IP NET_GATEWAY NET_DNS ELASTICSEARCH_IP; do
    echo "s}=$field}=${!field}}"
done | sed -i -f - "${ROOTFS_DIR}/boot/firstboot.config"

# Step 3:
# Change defaults under /etc to configfile variables 

# First list the files under /etc. Note that the "xargs echo" is
# necessary to avoid an error when some files return "permission
# denied"
FILES=$(
  find "${ROOTFS_DIR}/etc/" \
    -type f -and \( \
      -not \( -name resolv.conf -o -name hosts \) \
      -o -path "${ROOTFS_DIR}/etc/elasticsearch" -prune \
      -o -path "${ROOTFS_DIR}/etc/dnscache/log" -prune \
    \) \
    -print 2>/dev/null | sed -e 's}//}/}g' | xargs echo
)

# Then edit each one to change the actual values into dummies
for file in $FILES; do
    for field in TARGET_HOSTNAME HOST_IP NET_GATEWAY NET_DNS ELASTICSEARCH_IP; do
        echo "s}${!field}}$field}"
    done | sed -i -f - "$file"
done

