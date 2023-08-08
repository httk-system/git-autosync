#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)

find . -type d -name ".git" -prune | while read LINE; do
    DIR=$(dirname "$LINE")
    (
        REPONAME=$(basename "$DIR")

        if [ ! -e ~/".git-autosync/worktrees/$REPONAME" ]; then
            echo "Skipping $DIR (no .git-autosync/worktree directory)"
        else
            cd "$DIR"
            "$SCRIPT_DIR/git-autosync-commit.sh" .
        fi
    )
done
