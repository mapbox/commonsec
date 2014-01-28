## Common Sense Security

A few small configuration changes to tighten SSH security, meant only as a
starting point.

## Requirements

Tested on Ubuntu 12.04.

## Install

`./bin/setup.bash /etc`

or

`./bin/setup.bash /etc kermit 22222`

where "kermit" is the SSH user you'd like to grant SSH access, and 22222 is the
port on which sshd should run.

## What it does

- Allows SSH on specified port for specified user
- Uses ip_conntrack to limit SSH login attempts
- Disables SSH password login
- Disables root login

Warning, this will overwrite:

- /etc/ssh/sshd_config
- Your iptables settings
