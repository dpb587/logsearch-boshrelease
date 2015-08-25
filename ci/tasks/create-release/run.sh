#!/bin/bash

set -e
set -u

cd "${PWD}/repo"

EXTRA_OPTS="${EXTRA_OPTS:-}"

if [[ "true" == "${FINAL_RELEASE:-}" ]] ; then
  EXTRA_OPTS="${EXTRA_OPTS} --final"
fi
  
bosh -n create release \
  $EXTRA_OPTS \
  --version="$( cat ../version/number )" \
  --with-tarball

[[ "true" == "${FINAL_RELEASE:-}" ]] || exit


