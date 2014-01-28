#!/usr/bin/env bash

verbose=$1

# Default
mkdir -p ./test/etc
make test
for file in `ls ./test/etc`;
do
    result=$(diff ./test/etc/$file ./test/fixtures/$file.default)
    if [ $? -eq 0 ]; then
        echo "[pass] $file default"
    else
        echo "[fail] $file default"
        if [ -n "$verbose" ]; then
            echo "$verbose"
        fi
    fi
done
rm -r ./test/etc

# Override
mkdir -p ./test/etc
make test user=kermit port=22222
for file in `ls ./test/etc`;
do
    result=$(diff ./test/etc/$file ./test/fixtures/$file.override)
    if [ $? -eq 0 ]; then
        echo "[pass] $file override"
    else
        echo "[fail] $file override"
        if [ -n "$verbose" ]; then
            echo "$verbose"
        fi
    fi
done
rm -r ./test/etc
