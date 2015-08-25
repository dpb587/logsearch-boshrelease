#!/bin/bash

set -e
set -u

cd "${PWD}/repo"

EXTRA_OPTS="${EXTRA_OPTS:-}"
FINAL_RELEASE="${FINAL_RELEASE:-false}"
VERSION=$( cat ../version/number )

if [[ "true" == "$FINAL_RELEASE" ]] ; then
  EXTRA_OPTS="${EXTRA_OPTS} --final"
else
  VERSION_BUILD=$( git rev-parse HEAD | cut -c -10 )
  VERSION="${VERSION}+rev.${VERSION_BUILD}"
fi
  
bosh -n create release \
  $EXTRA_OPTS \
  --version="$( cat ../version/number )" \
  --with-tarball

echo "${VERSION}" > VERSION

if [[ "true" == "$FINAL_RELEASE" ]] ; then
  exit
fi

git add -A .final_builds releases

(
  echo "Release v$VERSION"
  echo ""
  cat releases/logsearch-$VERSION.md
) \
  | git commit -F-
