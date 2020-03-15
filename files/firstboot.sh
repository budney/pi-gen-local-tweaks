#!/bin/bash -e
# This script runs at boot time, and uninstalls itself
# upon success.

SUCCESS=""

uninstall_self() {
    systemctl disable firstboot
    rm -f /lib/systemd/system/firstboot.service
    rm -f /etc/firstboot.sh
    rm -f /boot/firstboot.config
}

finalize() {
    if [ -z "$SUCCESS" ]; then
        exit 0
    fi

    uninstall_self
    /sbin/reboot
}
trap finalize EXIT

# This script is called "firstboot." If the
# config file isn't there, we do nothing.
if [ ! -e /boot/firstboot.config ]; then
    SUCCESS=1
    exit 0
fi
source /boot/firstboot.config

# List the files under /etc. Note that the "xargs echo"
# is necessary to avoid an error when some files return
# "permission denied"
FILES=$(
  find /etc/ \
    -type f \
    -not \( -name resolv.conf -o -name hosts \) \
    -o -path '/etc/elasticsearch' -prune \
    -o -path /etc/dnscache/log -prune \
    -o -print \
  2>/dev/null | sed -e 's}//}/}g' | xargs echo
)

# Then edit each one to change the actual values into dummies
for file in $FILES; do
    for field in TARGET_HOSTNAME HOST_IP NET_GATEWAY NET_DNS ELASTICSEARCH_IP; do
        echo "s}$field}${!field}}"
    done | sed -i -f - "$file"
done

# If there's a firstboot script, run it, too
if [ -x /boot/firstboot.sh ]; then
    /boot/firstboot.sh
fi

# That's it!
SUCCESS=1
