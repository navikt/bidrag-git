#!/bin/bash
set -e

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

if ! git diff --quiet
then
  if [[ -z $INPUT_COMMIT_MESSAGE_FILE ]]
  then
    echo "No file to replace commit message is added to the input"
  else
    if [[ -f $INPUT_COMMIT_MESSAGE_FILE ]]
    then
      REPLACE_MESSAGE=$(cat "$INPUT_COMMIT_MESSAGE_FILE")
      COMMIT_MESSAGE=$(echo "$INPUT_COMMIT_MESSAGE" | sed "s;{};$REPLACE_MESSAGE;")
    else
      echo "Is not a file: $INPUT_COMMIT_MESSAGE_FILE"
    fi
  fi

  echo "Committing changes with message: $COMMIT_MESSAGE"

  git add "$INPUT_PATTERN"
  git commit -m "$COMMIT_MESSAGE"
  git push

else
  echo "No difference detected."
fi
