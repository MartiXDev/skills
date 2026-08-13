#!/usr/bin/env sh

set -eu

usage() {
    printf "%s\n" \
        "Usage: git-cleanup.sh [--repo <path>] [--fetch] [--apply]" \
        "                      [--base <branch-or-ref>] [--github-merged]" \
        "                      [--prune-worktree-metadata]" \
        "                      [--what-if] [--no-confirm]" \
        "" \
        "Compatibility launcher for git-cleanup.ps1 (PowerShell 7+)." \
        "Default: audit only; no worktrees or branches are removed." \
        "--no-confirm explicitly suppresses PowerShell confirmation prompts." \
        "" \
        "Weekly example:" \
        "  git-cleanup.sh --repo <path> --fetch --apply --github-merged --no-confirm"
}

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
POWERSHELL_SCRIPT="$SCRIPT_DIR/git-cleanup.ps1"

[ -f "$POWERSHELL_SCRIPT" ] || {
    echo "PowerShell cleanup script not found: $POWERSHELL_SCRIPT" >&2
    exit 2
}
command -v pwsh >/dev/null 2>&1 || {
    echo "PowerShell 7 executable not found: pwsh" >&2
    exit 2
}

REPOSITORY_PATH=""
BASE_REF=""
FETCH=false
APPLY=false
GITHUB_MERGED=false
PRUNE_WORKTREE_METADATA=false
WHAT_IF=false
NO_CONFIRM=false
VERBOSE=false

while [ "$#" -gt 0 ]; do
    case "$1" in
        --repo|-RepositoryPath)
            shift
            [ "$#" -gt 0 ] || { echo "Missing value for repository path" >&2; exit 2; }
            [ -n "$1" ] || { echo "Repository path cannot be empty" >&2; exit 2; }
            REPOSITORY_PATH=$1
            ;;
        --base|-Base)
            shift
            [ "$#" -gt 0 ] || { echo "Missing value for base branch" >&2; exit 2; }
            [ -n "$1" ] || { echo "Base branch cannot be empty" >&2; exit 2; }
            BASE_REF=$1
            ;;
        --fetch|-Fetch) FETCH=true ;;
        --apply|-Apply) APPLY=true ;;
        --github-merged|-GitHubMerged) GITHUB_MERGED=true ;;
        --prune-worktree-metadata|-PruneWorktreeMetadata) PRUNE_WORKTREE_METADATA=true ;;
        --what-if|-WhatIf) WHAT_IF=true ;;
        --no-confirm) NO_CONFIRM=true ;;
        -Verbose) VERBOSE=true ;;
        -h|--help|-\?)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Invoke git-cleanup.ps1 directly for additional PowerShell common parameters." >&2
            exit 2
            ;;
    esac
    shift
done

if [ "$NO_CONFIRM" = true ]; then
    set -- -NoProfile -NonInteractive -File "$POWERSHELL_SCRIPT"
else
    set -- -NoProfile -File "$POWERSHELL_SCRIPT"
fi
[ -n "$REPOSITORY_PATH" ] && set -- "$@" -RepositoryPath "$REPOSITORY_PATH"
[ "$FETCH" = true ] && set -- "$@" -Fetch
[ "$APPLY" = true ] && set -- "$@" -Apply
[ -n "$BASE_REF" ] && set -- "$@" -Base "$BASE_REF"
[ "$GITHUB_MERGED" = true ] && set -- "$@" -GitHubMerged
[ "$PRUNE_WORKTREE_METADATA" = true ] && set -- "$@" -PruneWorktreeMetadata
[ "$WHAT_IF" = true ] && set -- "$@" -WhatIf
[ "$NO_CONFIRM" = true ] && set -- "$@" '-Confirm:$false'
[ "$VERBOSE" = true ] && set -- "$@" -Verbose

exec pwsh "$@"