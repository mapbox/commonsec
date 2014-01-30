## Common Sense Security

A few small configuration changes to tighten SSH security, meant only as a
starting point.

## Requirements

Tested on Ubuntu 12.04.

## Install

`./bin/setup.bash`

#### Optional arguments

- -p `<port-number>`
- -u `<user>`

## What it does

- Creates login user for specified user
- Allows SSH on specified port for specified user
- Uses ip_conntrack to limit SSH login attempts
- Disables SSH password login
- Disables root login
- Adds user to sudoers

Warning, this will overwrite:

- /etc/ssh/sshd_config
- Your iptables settings
- Make modifications in /etc/sudoers.d
