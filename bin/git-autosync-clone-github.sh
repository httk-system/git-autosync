#!/bin/bash

set -e

if [ "$#" -lt "1" ]; then
    echo "Usage: $0 <repo> <git-as branch> [dest path]"
    exit 1
fi

REPO=$1
if [ -z "$2" ]; then
    BRANCH="git-autosync_$(hostname)"
else
    BRANCH=$2
fi
if [ -z "$3" ]; then
    REPONAME=$(basename "$REPO" .git)
    DEST="./$REPONAME"
else
    DEST="$3"
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
if [ ! -e "$REPONAME" ]; then
    git clone "$REPO" "$DEST"
fi
cd "$DEST"
git config core.sshCommand "ssh -o IdentityAgent=none -o IdentitiesOnly=yes -i ~/.ssh/git-autosync/\"$REPONAME\""

if [ ! -e ~/.git-autosync/worktrees ]; then
    mkdir -p ~/.git-autosync/worktrees
fi
if [ ! -e ~/".git-autosync/worktrees/$REPONAME/" ]; then
    git worktree add ~/".git-autosync/worktrees/$REPONAME/" -b "$BRANCH" --no-checkout
fi
