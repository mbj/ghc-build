#!/bin/sh

set -x -e

podman build . --tag debug

podman run \
 --rm \
 --name ghc-build \
 --interactive \
 --tty \
 --mount type=bind,src=$(pwd),target=/opt/build \
 --cpus=16 \
 --workdir /opt/build \
 debug \
./build.sh
