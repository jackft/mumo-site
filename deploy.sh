#!/usr/bin/env bash
set -xeuo pipefail
# before running this script: git worktree add gh-pages gh-pages
[[ $# -lt 1 ]] && { echo "Usage: $0 <mumo-repo-path>"; exit 1; }
MUMO_REPO="$(realpath "$1")"
SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

(cd "$MUMO_REPO" && npm run build)
rsync -av --delete "$MUMO_REPO/packages/mumo/dist/" "$SITE/static/app/"

# Build Hugo site
hugo -s "$SITE" --minify

cp -r public/* gh-pages
