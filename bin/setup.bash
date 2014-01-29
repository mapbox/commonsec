#!/usr/bin/env bash

op=$1
config_path=$2
user=$3
user=${user:-gonzo}
port=$4
port=${port:-12345}

if [[ $op -ne "test" ]] || [[ $op -ne "install" ]]; then
    echo "First argument must be one of 'test' or 'install'"
    exit 1
fi

if [ -z "$config_path" ]; then
    echo "Must provide configuration path."
    exit 1
fi

if [ ! -d "$config_path" ]; then
    echo "Configuration path must be a directory."
    exit 1
fi

sed -e "s/%USER/$user/g" -e "s/%PORT/$port/g" < ./etc/ssh/sshd_config > $config_path/ssh/sshd_config
sed "s/%PORT/$port/g" ./etc/iptables.txt > $config_path/iptables.txt
echo "net.ipv4.netfilter.ip_conntrack_max=262144" >> $config_path/sysctl.conf
echo "net.ipv4.ip_local_port_range=10000 65535" >> $config_path/sysctl.conf
echo "$user ALL=NOPASSWD: ALL" > $config_path/sudoers.d/60_$user
chmod 440 $config_path/sudoers.d/60_$user

if [ "$op" = "install" ]; then
    restart ssh
    modprobe ip_conntrack
    /sbin/sysctl -p
    iptables-restore < /etc/iptables.txt
fi
