#!/bin/bash

if [[ -f /root/.ssh/git/id_rsa && -f /root/.ssh/git/id_rsa.pub ]]; then
    mv -f /root/.ssh/git/id_rsa /root/.ssh/
    mv -f /root/.ssh/git/id_rsa.pub /root/.ssh/
    chmod 0600 /root/.ssh/id_rsa
    ssh-keyscan -H bitbucket.org >> /root/.ssh/known_hosts
fi

for f in /usr/local/bin/service_reinitializers/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

if [[ -f /root/.ssh/id_rsa && -f /root/.ssh/id_rsa.pub ]]; then
    rm -f /root/.ssh/id_rsa
    rm -f /root/.ssh/id_rsa.pub
fi