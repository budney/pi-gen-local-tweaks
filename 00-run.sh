#!/bin/bash -e
# Download source files

for URL in $(cat sources.txt); do
    ( cd files; curl -O ${URL}; )
done

