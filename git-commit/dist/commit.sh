#!/bin/bash
set -e

echo 'Files staged for commit'
git diff --name-only

if ! git diff --quiet
then
  if [[ -z $INPUT_COMMIT_MESSAGE_FILE ]]
  then
    if [[ -f $INPUT_COMMIT_MESSAGE_FILE ]]
    then
      REPLACE_MESSAGE=$(cat $INPUT_COMMIT_MESSAGE_FILE)
      INPUT_COMMIT_MESSAGE=$(echo "$INPUT_COMMIT_MESSAGE" | sed "s;{};$(REPLACE_MESSAGE)")
    else
      echo "Is not a faile: &INPUT_COMMIT_MESSAGE_FILE"
    fi
  fi

  git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
  git config --global user.email "$INPUT_AUTHOR_EMAIL"
  git config --global user.name "$INPUT_AUTHOR_NAME"

  echo "Commiting changes with commit message: $INPUT_COMMIT_MESSAGE"

  git add "$INPUT_PATTERN"
  git commit -m "$INPUT_COMMIT_MESSAGE"
  git push
else
  echo "No files staged for commit."
fi
