#!/bin/bash

set -e
set -u

cd "$PWD/repo-base"

git config user.email "${CI_EMAIL:-ci@localhost}"
git config user.name "${CI_NAME:-CI Bot}"

PR_COMMIT=$( cd ../repo-head ; git rev-parse HEAD )
git remote add --fetch repo-head file://$PWD/../repo-head
git merge $PR_COMMIT < /dev/null

cd ..

shopt -s dotglob nullglob
mv repo-base/* ./

rm -fr repo-base repo-head
