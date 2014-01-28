#!/usr/bin/env bash

ok="true"

# Default
mkdir -p ./test/etc/ssh
make test

diff ./test/etc/iptables.txt ./test/fixtures/iptables.txt.default

if [ $? -eq 1 ]; then
    ok="false"
    echo "iptables.txt default templating failure"
fi

diff ./test/etc/ssh/sshd_config ./test/fixtures/sshd_config.default

if [ $? -eq 1 ]; then
    ok="false"
    echo "sshd_config default templating failure"
fi

if [ "$ok" = "true" ]; then
    echo "Tests passed for default templating"
else
    echo "Tests failed for default templating"
fi

# Override
rm -r ./test/etc
mkdir -p ./test/etc/ssh
make test user=kermit port=22222

diff ./test/etc/iptables.txt ./test/fixtures/iptables.txt.override

if [ $? -eq 1 ]; then
    ok="false"
    echo "iptables.txt override templating failure"
fi

diff ./test/etc/ssh/sshd_config ./test/fixtures/sshd_config.override

if [ $? -eq 1 ]; then
    ok="false"
    echo "sshd_config override templating failure"
fi

if [ "$ok" = "true" ]; then
    echo "Tests passed for override templating"
else
    echo "Tests failed for override templating"
fi

