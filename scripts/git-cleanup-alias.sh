#!/usr/bin/env sh

set -eu

git rev-parse --show-toplevel >/dev/null 2>&1 || {
    echo "Run this script inside a Git repository." >&2
    exit 2
}

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LAUNCHER="$SCRIPT_DIR/git-cleanup.sh"
POWERSHELL_SCRIPT="$SCRIPT_DIR/git-cleanup.ps1"

if [ ! -f "$LAUNCHER" ] || [ ! -f "$POWERSHELL_SCRIPT" ]; then
    echo "Cleanup scripts not found under: $SCRIPT_DIR" >&2
    exit 2
fi
command -v pwsh >/dev/null 2>&1 || {
    echo "PowerShell 7 executable not found: pwsh" >&2
    exit 2
}

git config --local alias.cleanup "!sh \"$LAUNCHER\""
printf "Configured repository-local alias: git cleanup\n"
printf "Audit: git cleanup\n"
printf "Preview: git cleanup --apply --what-if\n"
printf "Apply after review: git cleanup --fetch --apply --github-merged --no-confirm\n"
