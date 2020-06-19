#!/bin/bash
set -e

############################################
#
# Følgende skjer i dette skriptet:
# 1) Konfigurerer git for remote repository
#    - USER_EMAIL og USER_NAME settes av javascriptet
# 2) Setter working directory til git folder
# 3) Når siste commit er samme dato/time og fra $INPUT_AUTHOR så avsluttes script
# 4) Sett commit message og pattern (fra javascript)
# 5) Når det er en endring i repository:
#    - legg til endringer ihht. pattern og commit med melding
#    - push kode til remote repository
#
############################################

if [[ -z "$INPUT_GIT_FOLDER" ]]; then
  echo "using $PWD as git repository"
else
  ls -all
  echo "git folder: $PWD/$INPUT_GIT_FOLDER"
  cd "$INPUT_GIT_FOLDER" || exit 1;
fi

LATEST_AUTHOR="$(git log --pretty=%an -1)"

if [[ "$LATEST_AUTHOR" == "$INPUT_AUTHOR" ]]; then
  LAST_COMMIT=$(git log --pretty=%cd -1)
  DATE=$(date)
  LAST_CHECK="${LAST_COMMIT%%:*}"
  LAST_DATE="${DATE%%:*}"

  if [[ "$LAST_CHECK" == "$LAST_DATE" ]]; then
      echo "the latest commit is done by $INPUT_AUTHOR@$LAST_COMMIT... skipping new commit"
      exit 0;
  fi
fi

git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

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
