#!/bin/bash

set -e
set -u

mv version .version

VERSION=$( cat .version/number )
URL=$( echo "$RELEASE_TGZ" | sed "s/{version}/$VERSION/" 

wget -O .src.tgz "$URL"

tar -xzf .src.tgz --strip-components=1

git get-tar-commit-id < .src.tgz > .commit
