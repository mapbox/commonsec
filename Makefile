user?=gonzo
port?=12345
config_path=./out

test: config_path = ./test/etc

all: install finish

install:

	sed -e 's/%USER/$(user)/g' -e 's/%PORT/$(port)/g' < ./etc/sshd_config > $(config_path)/sshd_config

	sed 's/%PORT/$(port)/g' ./etc/iptables.txt > $(config_path)/iptables.txt

	@echo "net.ipv4.netfilter.ip_conntrack_max=262144" >> $(config_path)/sysctl.conf
	@echo "net.ipv4.ip_local_port_range=10000 65535" >> $(config_path)/sysctl.conf

finish:

	restart ssh
	/sbin/sysctl -p

test: install

	./bin/test.bash

.PHONY: install finish test
