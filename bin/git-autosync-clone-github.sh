#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)

if [ "$#" -lt "1" ]; then
    echo "Usage: $0 <origin repo> <sync repo> [git-as branch] [dest path]"
    exit 1
fi

REPO=$1
SYNC_REPO=$2
if [ -z "$3" ]; then
    BRANCH="git-autosync_$(hostname)"
else
    BRANCH="$3"
fi
if [ -z "$4" ]; then
    REPONAME=$(basename "$REPO" .git)
    DEST="./$REPONAME"
else
    DEST="$4"
    REPONAME=$(basename "$DEST")
fi

if [ ! -e ~/.ssh/git-autosync ]; then
    mkdir -p ~/.ssh/git-autosync
    chmod go-rwx /home/rar/.ssh/git-autosync
fi
if [ ! -e  ~/.ssh/git-autosync/"$REPONAME" ]; then
    ssh-keygen -q -t ed25519 -C "<>" -f ~/.ssh/git-autosync/"$REPONAME" -N ""
fi
echo "== Make sure this is configured as a git-autosync key:"
cat ~/.ssh/git-autosync/"$REPONAME".pub
echo "===="

"$SCRIPT_DIR/git-autosync-clone.sh" "$@"

cd "$DEST"
git config git-autosync.sshCommand "ssh -o IdentityAgent=none -o IdentitiesOnly=yes -i ~/.ssh/git-autosync/\"$REPONAME\""
