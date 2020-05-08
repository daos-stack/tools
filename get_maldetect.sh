#!/bin/bash

set -uex

lmd_tarball='maldetect-current.tar.gz'

curl "http://rfxn.com/downloads/${lmd_tarball}" \
  -z "${lmd_tarball}" --retry 10 --retry-max-time 60 --silent --show-error \
  --fail -O

# sanity check to make sure we have a good tarball
tar -tf "${lmd_tarball}" > /dev/null
