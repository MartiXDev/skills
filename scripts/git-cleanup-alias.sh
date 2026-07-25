#!/usr/bin/env sh

set -eu

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Run this script inside a Git repository." >&2
    exit 2
}

if [ ! -f "$REPO_ROOT/scripts/git-cleanup.sh" ]; then
    echo "Cleanup script not found: $REPO_ROOT/scripts/git-cleanup.sh" >&2
    exit 2
fi

git config --local alias.cleanup '!exec "$(git rev-parse --show-toplevel)/scripts/git-cleanup.sh"'
printf "Configured repository-local alias: git cleanup\n"
printf "Audit: git cleanup\n"
printf "Apply only after review: git cleanup --apply\n"
