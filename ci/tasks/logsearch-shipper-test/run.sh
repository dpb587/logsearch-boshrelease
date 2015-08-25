#!/bin/bash

set -e
set -u

cd repo/

RELEASE_DIR=$PWD /usr/local/logsearch-shipper-release-utils/bin/test
