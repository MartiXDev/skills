#!/usr/bin/env sh

set -eu

APPLY=false
FETCH=false
BASE_BRANCH=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --apply) APPLY=true ;;
        --fetch) FETCH=true ;;
        --base)
            shift
            [ "$#" -gt 0 ] || { echo "Missing value for --base" >&2; exit 2; }
            BASE_BRANCH="$1"
            ;;
        -h|--help)
            printf "%s\n" \
                "Usage: git-cleanup.sh [--fetch] [--apply] [--base <branch>]" \
                "" \
                "Default: inspect only; do not delete branches, worktrees, or objects." \
                "--fetch  Refresh remote-tracking refs without pruning them." \
                "--apply  Remove only clean, merged local worktrees and branches." \
                "--base   Use a specific base branch instead of origin/HEAD, main, or master."
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Use git-cleanup.sh --help for usage." >&2
            exit 2
            ;;
    esac
    shift
done

if [ "$FETCH" = true ]; then
    echo "==> Fetching latest refs without pruning remote-tracking refs"
    git fetch --all
else
    echo "==> Skipping fetch; use --fetch to refresh remote-tracking refs"
fi

if [ -n "$BASE_BRANCH" ]; then
    MAIN_BRANCH=${BASE_BRANCH#refs/heads/}
    MAIN_REF=$BASE_BRANCH
else
    ORIGIN_HEAD=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null || true)
    if [ -n "$ORIGIN_HEAD" ]; then
        MAIN_BRANCH=${ORIGIN_HEAD#refs/remotes/origin/}
        if git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
            MAIN_REF="refs/heads/$MAIN_BRANCH"
        else
            MAIN_REF=$ORIGIN_HEAD
        fi
    elif git show-ref --verify --quiet refs/heads/main; then
        MAIN_BRANCH=main
        MAIN_REF=refs/heads/main
    elif git show-ref --verify --quiet refs/heads/master; then
        MAIN_BRANCH=master
        MAIN_REF=refs/heads/master
    else
        echo "Could not detect a base branch; use --base <branch>." >&2
        exit 2
    fi
fi

git rev-parse --verify --quiet "$MAIN_REF^{commit}" >/dev/null || {
    echo "Base branch does not resolve to a commit: $MAIN_REF" >&2
    exit 2
}
CURRENT_BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
echo "==> Base branch: $MAIN_BRANCH ($MAIN_REF)"

worktree_info() {
    TARGET="refs/heads/$1"
    PATH_VALUE=""
    BRANCH_VALUE=""
    LOCKED=false
    git worktree list --porcelain | while IFS= read -r LINE || [ -n "$LINE" ]; do
        case "$LINE" in
            "worktree "*) PATH_VALUE=${LINE#worktree } ;;
            "branch "*) BRANCH_VALUE=${LINE#branch } ;;
            locked*) LOCKED=true ;;
            "")
                if [ "$BRANCH_VALUE" = "$TARGET" ]; then
                    printf "%s\n%s\n" "$PATH_VALUE" "$LOCKED"
                    exit 0
                fi
                PATH_VALUE=""
                BRANCH_VALUE=""
                LOCKED=false
                ;;
        esac
    done
}

echo "==> Worktree state"
HAS_WORKTREE=false
if git worktree list --porcelain | awk '/^branch refs\/heads\// { found=1 } END { exit !found }'; then
    HAS_WORKTREE=true
fi
git worktree list --porcelain | while IFS= read -r LINE || [ -n "$LINE" ]; do
    case "$LINE" in
        "worktree "*) PATH_VALUE=${LINE#worktree } ;;
        "branch refs/heads/"*) BRANCH_VALUE=${LINE#branch refs/heads/} ;;
        locked*) LOCKED=true ;;
        "")
            if [ -n "${BRANCH_VALUE:-}" ]; then
                if [ -d "$PATH_VALUE" ]; then
                    if [ -n "$(git -C "$PATH_VALUE" status --porcelain=v1 --untracked-files=all)" ]; then
                        STATE=CHANGED
                    else
                        STATE=clean
                    fi
                else
                    STATE=MISSING
                fi
                [ "${LOCKED:-false}" = true ] && STATE="$STATE, locked"
                printf "  %s\n    path: %s\n    state: %s\n" "$BRANCH_VALUE" "$PATH_VALUE" "$STATE"
            fi
            PATH_VALUE=""
            BRANCH_VALUE=""
            LOCKED=false
            ;;
    esac
done
[ "$HAS_WORKTREE" = true ] || echo "No branch-attached worktrees found."

MERGED_BRANCHES=$(git for-each-ref --merged="$MAIN_REF" --format="%(refname:short)" refs/heads/)
echo "==> Safe cleanup candidates"
printf "%s\n" "$MERGED_BRANCHES" | while IFS= read -r BRANCH || [ -n "$BRANCH" ]; do
    [ -n "$BRANCH" ] || continue
    [ "$BRANCH" = "$MAIN_BRANCH" ] && continue
    INFO=$(worktree_info "$BRANCH")
    WT_PATH=$(printf "%s\n" "$INFO" | sed -n '1p')
    WT_LOCKED=$(printf "%s\n" "$INFO" | sed -n '2p')
    if [ -z "$WT_PATH" ]; then
        echo "  $BRANCH (merged; no worktree)"
        if [ "$APPLY" = true ]; then
            git branch -d -- "$BRANCH"
            echo "    deleted local branch"
        fi
    elif [ ! -d "$WT_PATH" ]; then
        echo "  $BRANCH (retained; worktree path is missing: $WT_PATH)"
    elif [ -n "$(git -C "$WT_PATH" status --porcelain=v1 --untracked-files=all)" ]; then
        echo "  $BRANCH (retained; worktree has changes: $WT_PATH)"
    elif [ "$WT_LOCKED" = true ]; then
        echo "  $BRANCH (retained; worktree is locked: $WT_PATH)"
    elif [ "$BRANCH" = "$CURRENT_BRANCH" ]; then
        echo "  $BRANCH (retained; currently checked out: $WT_PATH)"
    else
        echo "  $BRANCH (merged; clean worktree: $WT_PATH)"
        if [ "$APPLY" = true ]; then
            if git worktree remove "$WT_PATH"; then
                git branch -d -- "$BRANCH"
                echo "    removed worktree and deleted local branch"
            else
                echo "    retained because worktree removal failed" >&2
            fi
        fi
    fi
done

UNMERGED_BRANCHES=$(git for-each-ref --no-merged="$MAIN_REF" --format="%(refname:short)" refs/heads/)
echo "==> Next steps"
if [ -z "$UNMERGED_BRANCHES" ]; then
    echo "No unmerged local branches need publishing or PR review."
else
    printf "%s\n" "$UNMERGED_BRANCHES" | while IFS= read -r BRANCH || [ -n "$BRANCH" ]; do
        [ -n "$BRANCH" ] || continue
        INFO=$(worktree_info "$BRANCH")
        WT_PATH=$(printf "%s\n" "$INFO" | sed -n '1p')
        UPSTREAM=$(git for-each-ref --format="%(upstream:short)" "refs/heads/$BRANCH")
        COMMITS_AHEAD=$(git rev-list --count "$MAIN_REF..refs/heads/$BRANCH")
        echo "  Branch: $BRANCH"
        if [ -n "$WT_PATH" ] && [ -d "$WT_PATH" ]; then
            echo "    Worktree: $WT_PATH"
            if [ -n "$(git -C "$WT_PATH" status --porcelain=v1 --untracked-files=all)" ]; then
                echo "    1. Review and commit changes:"
                echo "       git -C \"$WT_PATH\" status"
                echo "       git -C \"$WT_PATH\" add -A && git -C \"$WT_PATH\" commit -m \"<message>\""
            else
                echo "    Worktree is clean."
            fi
        elif [ -n "$WT_PATH" ]; then
            echo "    1. Recover or repair the missing worktree: git worktree repair \"$WT_PATH\""
        else
            echo "    1. Inspect or create a worktree:"
            echo "       git log --oneline \"$MAIN_REF..refs/heads/$BRANCH\""
            echo "       git worktree add ../$BRANCH \"$BRANCH\""
        fi
        HAS_ORIGIN=false
        if git remote get-url origin >/dev/null 2>&1; then
            HAS_ORIGIN=true
        fi
        if [ "$COMMITS_AHEAD" -eq 0 ]; then
            echo "    2. Compare this branch with $MAIN_BRANCH before publishing; it has no commits ahead."
        elif [ -n "$UPSTREAM" ]; then
            echo "    2. Push pending commits: git push \"$UPSTREAM\""
        elif [ "$HAS_ORIGIN" = true ]; then
            echo "    2. Publish the branch: git push -u origin \"$BRANCH\""
        else
            echo "    2. Configure a remote before publishing this branch."
        fi
        echo "    3. Check for an existing PR: gh pr list --head \"$BRANCH\" --state all"
        echo "    4. If no PR exists, create one: gh pr create --base \"$MAIN_BRANCH\" --head \"$BRANCH\""
    done
fi

STALE_WORKTREE_METADATA=$(git worktree prune --dry-run --verbose 2>&1 || true)
if [ -n "$STALE_WORKTREE_METADATA" ]; then
    echo "==> Stale worktree metadata (not pruned):"
    echo "$STALE_WORKTREE_METADATA"
    echo "Review missing paths before running git worktree prune manually."
fi
echo "==> Object cleanup skipped"
echo "No git gc or git prune was run; unreachable objects remain recoverable."
if [ "$APPLY" = true ]; then
    echo "==> Safe cleanup complete"
else
    echo "==> Audit complete; rerun with --apply only after reviewing the report"
fi
