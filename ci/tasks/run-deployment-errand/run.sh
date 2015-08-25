#!/bin/bash

set -e
set -u

bosh -n target "${BOSH_TARGET}"
bosh -n login "${BOSH_USERNAME}" "${BOSH_PASSWORD}"

bosh \
  -n \
  -d "${DEPLOYMENT_FILE}" \
  run errand \
  "${ERRAND_NAME}"
