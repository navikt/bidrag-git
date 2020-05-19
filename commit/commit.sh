#!/bin/bash
set -x
############################################
#
# Følgende skjer i dette skriptet:
# 1) Konfigurerer git for remote repository
#    - USER_EMAIL og USER_NAME settes av javascriptet
# 2) Setter working directory til git folder
# 3) Når det er en endring i repository:
#    - Sett commit message og pattern (fra javascript)
#    - legg til endringer ihht. pattern og commit med melding
#    - push kode til remote repository
#
############################################

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

if [[ -z "$INPUT_GIT_FOLDER" ]]; then
  echo "using $PWD as git repository"
else
  ls -all
  echo "git folder: $PWD/$INPUT_GIT_FOLDER"
  cd "$INPUT_GIT_FOLDER"
fi

if ! git diff --quiet
then
  git status | grep -v "Your branch is" | grep -v "Changes not staged" | grep -v "(use \"git"

  INPUT_PATTERN=$1
  COMMIT_MESSAGE=$2

  echo "Committing changes (pattern: $INPUT_PATTERN) with message: $COMMIT_MESSAGE"

  git add "$INPUT_PATTERN"
  git commit -m "$COMMIT_MESSAGE"
  git push
else
  echo "No difference detected in $GITHUB_REPOSITORY, did not use pattern: $INPUT_PATTERN"
fi
