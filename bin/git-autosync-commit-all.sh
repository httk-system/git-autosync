#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)

find . -type d -name ".git" -prune | while read LINE; do
    DIR=$(dirname "$LINE")
    (
        cd "$DIR";
        "$SCRIPT_DIR/git-autosync-commit.sh" .
    )
done
