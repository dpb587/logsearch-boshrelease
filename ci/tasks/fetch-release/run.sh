#!/bin/bash

set -e
set -u

VERSION=$( cat ../version/number )

URL=$( echo "$RELEASE_TGZ" | sed "s/{version}/$VERSION/" 

wget -O tarball.tgz "$URL"

tar -xzf tarball.tgz release.MF

cd repo/

git rev-parse $( cat release.MF | grep '^commit_hash:' | awk '{ print $2 }' ) \
  > ../commit

echo "v$VERSION" > ../name

cp repo/release/logsearch-${VERSION}.md ../notes.md
