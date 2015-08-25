#!/bin/bash

set -e
set -u

cd "$PWD/repo"

git config user.email "${CI_EMAIL:-ci@localhost}"
git config user.name "${CI_NAME:-CI Bot}"

PR_COMMIT=$( cd ../repo-pr ; git rev-parse HEAD )
git remote add --fetch pr file://$PWD/../repo-pr
git merge $PR_COMMIT < /dev/null

mv
mv * .* ../

rm -fr repo repo-pr
