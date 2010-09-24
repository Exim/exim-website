#!/bin/sh

TARGET=${1-/srv/www/vhosts/www.exim.org}
LATEST=`(cd docbook; ls -1d [0-9].[0-9]* | tail -1)`

set -x
script/gen.pl \
  --web \
  --spec docbook/*/spec.xml \
  --filter  docbook/*/filter.xml \
  --latest ${LATEST} \
  --tmpl templates \
  --docroot ${TARGET}
