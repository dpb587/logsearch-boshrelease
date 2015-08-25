#!/bin/bash

set -e
set -u

VERSION=$( cat version/number )

cd src

bosh -n create release \
  --version="$VERSION" \
  --with-tarball

cd ../

mv src/src/dev_releases/*.tgz ./

rm -fr src version
