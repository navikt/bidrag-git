#!/bin/bash
set -e

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

echo 'Making a tag of the HEAD_COMMIT'

if [[ -z $INPUT_SRC_FOLDER ]]
then
  echo "Will not change working directory"
  pwd
else
  echo "Will try to change folder to $INPUT_SRC_FOLDER"
  cd "$INPUT_SRC_FOLDER"
fi

if [[ -f $INPUT_TAG_FILE ]]
then
  TAG=$(cat "$INPUT_TAG_FILE")
  TAG_MESSAGE=$(echo "$INPUT_TAG_MESSAGE" | sed "s;{};$TAG;")
else
  >&2 echo ::error Is not a file: $INPUT_TAG_FILE
  exit 1
fi

echo "Tagging HEAD_COMMIT with message: $TAG_MESSAGE"

git tag -a "$TAG" -m "$TAG_MESSAGE"
git push origin "$TAG"
