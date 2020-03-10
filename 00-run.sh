#!/bin/bash -e
# Download source files

cat /etc/resolv.conf > /tmp/resolv.conf.bak
echo "nameserver 8.8.8.8" > /etc/resolv.conf

cleanup() {
    cat /tmp/resolv.conf.bak > /etc/resolv.conf
}
trap cleanup EXIT

for URL in $(cat sources.txt); do
    ( cd files; curl -O ${URL}; )
done

