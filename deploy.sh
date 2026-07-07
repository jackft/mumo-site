#!/usr/bin/env bash
set -xeuo pipefail

# before running this script: git worktree add gh-pages gh-pages
[[ $# -lt 1 ]] && { echo "Usage: $0 <mumo-repo-path>"; exit 1; }

MUMO_REPO="$(realpath "$1")"
SITE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

(cd "$MUMO_REPO" && MUMO_BASE_PATH=/app/ pnpm run build:web)

mkdir -p "$SITE/static/app"
rsync -av --delete "$MUMO_REPO/packages/mumo/dist/" "$SITE/static/app/"

hugo -s "$SITE" --minify

cp -r public/* gh-pages
