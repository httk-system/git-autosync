#!/bin/bash

set -e

if [ "$#" -lt "1" ]; then
    echo "Usage: $0 <repo>"
    exit 1
fi

REPO=$1

cd "$REPO"
REPODIR=$(pwd -P .)
REPONAME=$(basename "$REPODIR")

if [ ! -e ~/.gitsync/worktrees ]; then
    mkdir -p ~/.gitsync/worktrees
fi
if [ -e ~/".gitsync/worktrees/$REPONAME/" ]; then
    git worktree remove ~/".gitsync/worktrees/$REPONAME/" --force
fi

BRANCH="$(hostname)_$(date +%Y-%m-%d_%H.%M.%S)"
git worktree add ~/".gitsync/worktrees/$REPONAME/" -b "$BRANCH" --no-checkout
rsync -aq ./ ~/".gitsync/worktrees/$REPONAME/" --exclude=/.git
cd ~/".gitsync/worktrees/$REPONAME/"
git add -A
git commit -m "Gitsync autocommit $BRANCH" --no-gpg-sign
git push --set-upstream origin "gitsync_$(hostname)"
#git worktree remove ~/".gitsync/$REPONAME/gitsync
