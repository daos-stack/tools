#!/bin/bash

set -uex

bullseye_url="https://www.bullseye.com/download"
dir_out="bullsye_dir.html"

# Need to get a directory listing of files for download
curl --location --retry 10 --retry-max-time 60 --silent --show-error \
  "${bullseye_url}" -o $dir_out

# Extract the filename from the listing
dnl_fname="$(sed -ne '/Linux-x64/s/.*href="\(.*\)\".*<\/a>.*/\1/p' $dir_out)"

# Check that we found one.
if [ -z "${dnl_fname}" ]; then
  echo "Failed to find Linux tarball to download"
  exit 1
fi

# If we do not have this filename downloaded, fetch it.
if [ ! -e "${dnl_fname}" ]; then
  # New version, get rid of older versions
  find . -name 'BullseyeCoverage-*-Linux-x64.tar*' -exec rm {} +

  # Pull down that version
  curl --location --retry 10 --retry-max-time 60 --silent --show-error \
    "${bullseye_url}/${dnl_fname}" -O
fi

rm -f ./bullseyecoverage-linux.tar
ln -s "${dnl_fname}" ./bullseyecoverage-linux.tar
