#!/bin/bash

set -uex

bullshtml_vers='master'
bullshtml_url='https://github.com/simplivity/bullshtml/archive/'
bullshtml_dnl="${bullshtml_vers}.tar.gz"
bullshtml_tar="bullshtml-${bullshtml_vers}.tar.gz"

curl --location --retry 10 --retry-max-time 60 --silent --show-error \
    -z "${bullshtml_tar}" \
    "${bullshtml_url}${bullshtml_dnl}" -o "${bullshtml_tar}"

if [ "${bullshtml_tar}" -nt bullshtml ]; then
  rm -rf bullshtml
  mkdir -p bullshtml
  tar -C bullshtml --strip-components=1 -xf "${bullshtml_tar}"
  pushd bullshtml
    # Use self contained build script that installs the gradle environment
    # and builds the resulting jar file.
    if [ ! -e build ]; then
      ./gradlew build
    fi
  popd
fi

rm -f ./bullshtml.jar
cp bullshtml/build/libs/bullshtml-*.jar ./bullshtml.jar

# Make sure we got a valid jar
unzip -t ./bullshtml.jar > /dev/null
