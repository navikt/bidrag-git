#!/bin/bash
set -e

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

if ! git diff --quiet
then
  git status

  COMMIT_MESSAGE="$1"
  PATTERN="$2"

  echo "Committing changes (pattern: '$PATTERN') with message: $COMMIT_MESSAGE"

  git add "$PATTERN"
  git commit -m "$COMMIT_MESSAGE"
  git push
else
  echo "No difference detected."
fi
