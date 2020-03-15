#!/bin/bash -e
# Install djbdns and other DJB tools

# Step 2:
# Build and install the tools

cd /tmp/

# Downlaod and build ucspi-tcp
tar -xf ucspi-tcp-0.88.tar.gz
cd ucspi-tcp-0.88
patch -p1 < /tmp/ucspi-tcp-0.88.errno.patch
make
make setup check

# Install daemontools, which uses slashpackage
test -d /package || mkdir /package
cd /package
tar xzf /tmp/daemontools-0.76.tar.gz
cd admin/daemontools-0.76
patch -p1 < /tmp/daemontools-0.76.errno.patch
./package/install
sed -i -e '/svscanboot/d' /etc/rc.local

# Build djbdns
cd /tmp/
tar xzf djbdns-1.05.tar.gz
cd djbdns-1.05
echo gcc -O2 -include /usr/include/errno.h > conf-cc
make
make setup check

# Now setup a DNS cache that forwards to the main cache
if ! id -u Gdnscache >/dev/null 2>&1; then
    useradd -d / -M -N -s /bin/true -c "DNS User" Gdnscache
fi
if ! id -u Gdnslog >/dev/null 2>&1; then
    useradd -d / -M -N -s /bin/true -c "DNS Log User" Gdnslog
fi
rm -rf /etc/dnscache /service/dnscache
dnscache-conf Gdnscache Gdnslog /etc/dnscache
echo ${NET_DNS} > /etc/dnscache/root/servers/@
echo 1 > /etc/dnscache/env/FORWARDONLY
ln -s /etc/dnscache /service/dnscache

# Enable daemontools service
systemctl enable daemontools
