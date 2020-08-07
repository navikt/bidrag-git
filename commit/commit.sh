#!/bin/bash
set -x

############################################
#
# Følgende skjer i dette skriptet:
# 1) Konfigurerer git for remote repository
#    - USER_EMAIL og USER_NAME settes av javascriptet
# 2) Setter working directory til $RUNNER_WORKSPACE/<project name>
# 3) Når siste commit er samme dato/time og fra $INPUT_AUTHOR så avsluttes script
# 4) Sett input fra javascript
# 5) Når det er en endring i repository:
#    - legg til endringer ihht. pattern og commit med melding
#    - push kode til remote repository
#
############################################

REPO_FOLDER="$(echo "$RUNNER_WORKSPACE/$GITHUB_REPOSITORY" | sed 's;navikt/;;')"
echo "Goto $REPO_FOLDER"
cd "$REPO_FOLDER" || exit 1

LATEST_AUTHOR="$(git log --pretty=%an -1)"

if [[ "$LATEST_AUTHOR" == "$INPUT_AUTHOR" ]]; then
  LAST_COMMIT=$(git log --pretty=%cd -1)
  DATE=$(date)
  LAST_CHECK="${LAST_COMMIT%%:*}"
  LAST_DATE="${DATE%%:*}"

  if [[ "$LAST_CHECK" == "$LAST_DATE" ]]; then
      echo "the latest commit is done by $INPUT_AUTHOR@$LAST_COMMIT... skipping new commit"
      exit 0
  fi
fi

INPUT_COMMIT_MESSAGE=$1
INPUT_PATTERN=$2
INPUT_SECURITY_TOKEN=$3

if [[ -z "$INPUT_SECURITY_TOKEN" ]]; then
  echo "No security token provided, using GITHUB_TOKEN"
else
  GITHUB_TOKEN=$INPUT_SECURITY_TOKEN
fi

git "$(echo "remote set-url origin https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git" | sed "s;';;")"
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

if ! git diff --quiet
then
  git status | grep -v "Your branch is" | grep -v "Changes not staged" | grep -v "(use \"git"

  echo "Committing changes (pattern: $INPUT_PATTERN) with message: $INPUT_COMMIT_MESSAGE"

  git add "$INPUT_PATTERN"
  git commit -m "$INPUT_COMMIT_MESSAGE"
  git push
else
  echo "No difference detected in $GITHUB_REPOSITORY, did not use pattern: $INPUT_PATTERN"
fi
