#!/usr/bin/env bash
set -euo pipefail

remote="${1:-upstream}"
branch="${2:-main}"

if ! git remote get-url "$remote" >/dev/null 2>&1; then
  echo "Remote '$remote' is not configured." >&2
  echo "Add it first, for example:" >&2
  echo "  git remote add upstream https://github.com/<original-org>/<repo>.git" >&2
  exit 2
fi

if [[ ! -f .gitattributes ]]; then
  echo "Missing .gitattributes; custom merge rules are not available." >&2
  exit 2
fi

git config merge.ours.driver true

echo "Fetching $remote..."
git fetch "$remote"

echo "Merging $remote/$branch into $(git branch --show-current)..."
git merge "$remote/$branch"

echo
echo "Upstream sync complete. Custom DNAnexus skill paths are protected by .gitattributes:"
echo "  skills/dnanexus-integration-custom/**"
echo "  tests/dnanexus-integration-custom/**"
echo "  docs/images/dnanexus-integration-custom.png"
