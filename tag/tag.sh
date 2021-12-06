#!/bin/bash
set -e

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

echo 'Making a tag of the HEAD_COMMIT'

git fetch --tags
SNAP_VERSION=$(git tag --sort=-v:refname --list "snapshot-[0-9]*" | head -n 1)
echo "Snapshot: $SNAP_VERSION"

# if there is no snapshot version tag yet, fail...
if [ -z "$SNAP_VERSION" ]; then
  echo ::error:: "No previous snapshot version detected!"
  exit 1
fi

NEW_V=$(echo "$SNAP_VERSION" | sed 's/snapshot-/v/')
echo "Current snapshot version will be the new released version: $NEW_V"

git tag -a "$NEW_V" -m "released version $NEW_V"
git push --follow-tags
