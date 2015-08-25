#!/bin/bash

set -e
set -u

VERSION=$( cat version/number )

RELEASE_DIR="${RELEASE_DIR:-repo}"

cd "$PWD/$RELEASE_DIR"

EXTRA_OPTS="${EXTRA_OPTS:-}"
FINAL_RELEASE="${FINAL_RELEASE:-false}"

if [[ "true" == "$FINAL_RELEASE" ]] ; then
  EXTRA_OPTS="$EXTRA_OPTS --final"
fi

bosh -n create release \
  $EXTRA_OPTS \
  --version="$VERSION" \
  --with-tarball

if [[ "true" != "$FINAL_RELEASE" ]] ; then
  exit
fi

#
# create final release
#

git config user.email "${CI_EMAIL:-ci@localhost}"
git config user.name "${CI_NAME:-CI Bot}"

git add -A .final_builds releases

(
  set -e
  echo "Release v$VERSION"
  echo ""
  cat releases/logsearch-$VERSION.md
) \
  | git commit -F-


#
# write out some metadata
#

echo "v$VERSION" > ../name
cp releases/logsearch-$VERSION.md ../notes.md
git rev-parse HEAD > ../commit
