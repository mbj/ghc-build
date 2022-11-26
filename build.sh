#!/bin/sh

set -x -e

cd build
cd ghc-9.2.4
./configure
cabal update
export XZ_OPT="-T0u
# export GHCRTS="-A128m -n4m"
# hadrian/build -j test --skip-perf
# hadrian/build -j binary-dist --docs=none --flavour=perf
hadrian/build -j test --skip-perf --flavour=perf
