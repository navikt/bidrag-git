#!/bin/bash
set -e

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

git fetch --tags
OLD_V=$(git tag --sort=-v:refname --list "snapshot-[0-9]*" | head -n 1)
echo "Old snapshot: $OLD_V"

# if there is no version tag yet, let's start at 0.0.0
if [ -z "$OLD_V" ]; then
  echo "No existing version, starting at 0.0.0"
  OLD_V="0.0.0"
fi

NEW_V=$(docker run --rm -v "$PWD":/app treeder/bump --input "$OLD_V" patch)
echo "New snapshot: $NEW_V"

git tag -a "snapshot-$NEW_V" -m "snapshot version $NEW_V"
git push --follow-tags
