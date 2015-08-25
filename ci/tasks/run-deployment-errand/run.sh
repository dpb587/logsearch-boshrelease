#!/bin/bash

set -e
set -u

bosh -n target "${BOSH_TARGET}"
bosh -n login "${BOSH_USER}" "${BOSH_PASSWORD}"

bosh \
  -d "${BOSH_DEPLOYMENT_FILE}" \
  run errand \
  "${ERRAND_NAME}"
