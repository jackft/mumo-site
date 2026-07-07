#!/usr/bin/env bash
set -euo pipefail

[[ $# -lt 1 ]] && { echo "Usage: $0 <mumo-repo-path>"; exit 1; }
MUMO_REPO="$(realpath "$1")"
SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

trap 'git -C "$SITE" worktree remove --force gh-pages 2>/dev/null; rm -rf "$SITE/gh-pages" "$SITE/public" "$SITE/static/app"' EXIT

# Build webapp
(cd "$MUMO_REPO" && npm run build)
rsync -a --delete "$MUMO_REPO/packages/mumo/dist/" "$SITE/static/app/"

# Build site
hugo -s "$SITE" --minify

# Deploy
git -C "$SITE" worktree add gh-pages gh-pages
rsync -a --delete "$SITE/public/" "$SITE/gh-pages/"
git -C "$SITE/gh-pages" add -A
git -C "$SITE/gh-pages" commit -m "deploy $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
git -C "$SITE/gh-pages" push origin gh-pages
