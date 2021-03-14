#!/bin/bash
set -e

############################################
#
# Følgende skjer i dette skriptet:
# 1) Setter working directory til $RUNNER_WORKSPACE/<project name> (folder som inneholder .git))
# 2) Sett input fra action
# 3) Setter security token fra input eller bruker GITHUB_TOKEN
# 4) Konfigurerer git ihht. git commit fra workflow
# 5) Når det er en endring i repository:
#    - kjører git status (suppress noe output)
#    - legg til endringer ihht. pattern
#    - commit med melding
#    - push kode til remote repository hvis det ble gjort en commit (endringene var faktiske endringer)
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

git remote set-url origin "$(echo "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git" | sed "s;';;g")"
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

if ! git diff-files --quiet
then
  git status | grep -v "Your branch is" | grep -v "Changes not staged" | grep -v "(use \"git"

  git add "$INPUT_PATTERN"
  git commit -m "$INPUT_COMMIT_MESSAGE" 2> /dev/null

  if [ $? -ne 0 ]; then
    echo "Unnable to commit into $GITHUB_REPOSITORY! pattern: $INPUT_PATTERN, exit code from commit: $?"
    exit
  fi

  echo "Committing changes (pattern: $INPUT_PATTERN) with message: $INPUT_COMMIT_MESSAGE"

  git push 2> /dev/null

  if [ $? -ne 0 ]; then
    echo ::error "exit code from push. $?"
    exit
  fi
else
  echo "No difference detected in $GITHUB_REPOSITORY, did not use pattern: $INPUT_PATTERN"
fi
