#!/bin/bash -e
# Install elasticsearch, if configured

if [ -z "$CONF_ELASTICSEARCH" ]; then
    exit 0
fi

# Step 2:
# Install...

# ...config files
cd /
tar xzf /tmp/elasticsearch.tgz
cp /tmp/elasticsearch /etc/default/

# ...GPG key
apt-key add /tmp/elasticsearch.gpg

# ...Java
apt-get install -y --autoremove default-jre-headless

# Set JAVA_HOME because elasticsearch scripts are braindead
export JAVA_HOME=/usr/lib/jvm/default-java
export ES_PATH_CONF=/etc/elasticsearch

# ...elasticsearch. This is guaranteed to fail, due to a JDK bug, so we have
# to lie and pretend success regardless.
dpkg -i --force-all --ignore-depends=libc6 /tmp/elasticsearch-7.6.1-amd64.deb \
    || /bin/true

# Patch for the JRE bug
( cd /usr/share/elasticsearch; patch -p0 < /tmp/elasticsearch-classpath-patch.txt; )

# Remove the dependency on libc6 that would make apt complain... FOREVER!
sed -i -e '/^Depends:.*libc6,/s/libc6, //' /var/lib/dpkg/status

# Install a fixed JNA jar to compensate for Elasticsearch brokenness
mv /usr/share/elasticsearch/lib/jna-4.5.1.jar /usr/share/elasticsearch/lib/jna-4.5.1.jar.old
cp /tmp/jna-5.5.0.jar /usr/share/elasticsearch/lib/

# Set the ownership correctly for config files
chown -R root:elasticsearch /etc/elasticsearch

# Point to the external volume where elasticsearch is located
ln -s /media/ssd/elasticsearch /var/share/elasticsearch

# Now complete the installation and do a repair for good measure
dpkg --configure elasticsearch:amd64
apt-get -f install

# FINALLY, enable the elasticsearch service. That seems to get skipped somehow
# in all the above fooling around.
systemctl enable elasticsearch

# And in support of elasticsearch, RE-enable swapfile support
apt-get install -y --autoremove dphys-swapfile
sed -i -e '/CONF_SWAPFILE=/aCONF_SWAPFILE=/media/ssd/swap' /etc/dphys-swapfile
rm -f /var/swap

