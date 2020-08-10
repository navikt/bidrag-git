#!/bin/bash
set -e

############################################
#
# Følgende forutsetninger for dette skriptet
# a) Miljøvariabler for git blir satt av javaskript
#    - USER_EMAIL og USER_NAME
#
# Følgende skjer i dette skriptet:
# 1) Setter working directory til $RUNNER_WORKSPACE/<project name>
# 2) Sett input fra javascript
# 3) Når det er en endring i repository:
#    - legg til endringer ihht. pattern og commit med melding
#    - push kode til remote repository
#
############################################

cd "$RUNNER_WORKSPACE" || exit 1
VERSION_CONTROLLED_FOLDER=$(find . -type d -name ".git" | head -n 1 | sed 's;./;;' | sed 's;/.git;;')
REPO_FOLDER="$RUNNER_WORKSPACE/$VERSION_CONTROLLED_FOLDER"
echo "Goto $REPO_FOLDER"
cd "$REPO_FOLDER" || exit 1

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
