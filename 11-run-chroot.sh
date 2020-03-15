#!/bin/bash -e
# Install GPG public key for backup manager

# Import the key, so backups can be encrypted.
gpg --import /tmp/pubkey.gpg

# Kill the GnuPG agent, which prevents the filesystem
# from being unmounted later:
ps aux |
    egrep gpg-agen[t] | \
    awk '{print $2}' | \
    xargs kill -9
