#!/bin/sh

if [ ! -d test/fixtures/incredibly_simple_rack_app.git ]; then
  cd ./test/fixtures
  git clone git://github.com/jdunphy/incredibly_simple_rack_app.git --mirror
fi
