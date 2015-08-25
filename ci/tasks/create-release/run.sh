#!/bin/bash

set -e
set -u

VERSION=$( cat version/number )

RELEASE_DIR="${RELEASE_DIR:-repo}"

cd "$PWD/$RELEASE_DIR"

EXTRA_OPTS="${EXTRA_OPTS:-}"
FINAL_RELEASE="${FINAL_RELEASE:-false}"
RELEASE_SRC_DIR="dev_releases-src/"

if [[ "true" == "$FINAL_RELEASE" ]] ; then
  EXTRA_OPTS="$EXTRA_OPTS --final"
  RELEASE_SRC_DIR="releases-src/"
fi

bosh -n create release \
  $EXTRA_OPTS \
  --version="$VERSION" \
  --with-tarball

if [[ "true" == "$FINAL_RELEASE" ]] ; then
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
fi

#
# dump the source code
#

mkdir $RELEASE_SRC_DIR/logsearch

COMMIT=$( git rev-parse HEAD )
COMMIT_SHORT=$( echo $COMMIT | cut -c -10 )

git archive \
  --format=tar.gz \
  --prefix=logsearch-$COMMIT_SHORT/ \
  $COMMIT \
  > $RELEASE_SRC_DIR/logsearch/logsearch-src-$VERSION.tgz
