#!/bin/sh

TARGET=${1-/srv/www/vhosts/dev.exim.org}

script/gen.pl \
  --web \
  --spec docbook/*/spec.xml \
  --filter  docbook/*/filter.xml \
  --latest 4.72 \
  --tmpl templates \
  --docroot ${TARGET}
