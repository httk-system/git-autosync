#!/bin/bash

set -e

if [ "$#" -lt "1" ]; then
    echo "Usage: $0 <repo> [dest path]"
    exit 1
fi

REPO=$1
if [ -z "$2" ]; then
    REPONAME=$(basename "$REPO" .git)
    DEST="./$REPONAME"
else
    DEST="$2"
    REPONAME=$(basename "$DEST")
fi

if [ ! -e ~/.ssh/gitsync ]; then
    mkdir -p ~/.ssh/gitsync
    chmod go-rwx /home/rar/.ssh/gitsync
fi
if [ ! -e  ~/.ssh/gitsync/"$REPONAME" ]; then
    ssh-keygen -q -t ed25519 -C "<>" -f ~/.ssh/gitsync/"$REPONAME" -N ""
fi
echo "== Make sure this is configured as a gitsync key:"
cat ~/.ssh/gitsync/"$REPONAME".pub
echo "===="
if [ ! -e "$REPONAME" ]; then
    git clone "$REPO" "$DEST"
fi
cd "$DEST"
git config core.sshCommand "ssh -o IdentitiesOnly=yes -i ~/.ssh/gitsync/\"$REPONAME\""
