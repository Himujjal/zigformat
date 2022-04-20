#!/usr/bin/env bash
SOME_DIR_IN_PATH=~/.local/bin

zig build -Drelease-safe=true

rm -rf $SOME_DIR_IN_PATH/zigformat
cp zig-out/bin/zigformat $SOME_DIR_IN_PATH
chmod u+x $SOME_DIR_IN_PATH/zigformat
