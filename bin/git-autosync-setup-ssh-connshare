#!/bin/bash

set -e

if [ "$#" -lt "1" ]; then
    echo "Usage: $0 <repo>"
    exit 1
fi

cd "$1"
REMOTE=$(git remote get-url origin)
RHOST="${REMOTE%%:*}"

if [ -e ~/".git-autosync/sockets/$REMOTE.socket" ]; then
    ssh -O exit -S ~/".git-autosync/sockets/$REMOTE.socket" "$RHOST" hostname
    rm -f ~/".git-autosync/sockets/$REMOTE.socket"
fi

echo "## Establishing master ssh connection (please login/enter password as needed)"
if ! ssh -M -S ~/".git-autosync/sockets/$REMOTE.socket" -o "ControlPersist=yes" "$RHOST" hostname > /dev/null; then
    echo "Failed to establish ssh connection to $RHOST"
    exit 1
fi
