#!/bin/bash

set -e
set -u

cd "${PWD}/repo"

EXTRA_OPTS="${EXTRA_OPTS:-}"
FINAL_RELEASE="${FINAL_RELEASE:-false}"
VERSION=$( cat ../version/number )

git config user.email "${CI_EMAIL:-ci@localhost}"
git config user.name "${CI_NAME:-CI Bot}"

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

git add -A .final_builds releases

(
  set -e
  echo "Release v$VERSION"
  echo ""
  cat releases/logsearch-$VERSION.md
) \
  | git commit -F-
