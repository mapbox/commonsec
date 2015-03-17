#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
base=${dir%/*}

### Parse arguments
while getopts ":u:p:t" opt; do
  case $opt in
    u)  user="$OPTARG" ;;
    p)  port="$OPTARG" ;;
    t)  config_path="$base/test/etc"
        op="test"
        ;;
    :)  echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
  esac
done

# Set default args
: ${config_path:="/etc"}
: ${op:="install"}
: ${user:="gonzo"}
: ${port:="12345"}

sed -e "s/%USER/$user/g" -e "s/%PORT/$port/g" < $base/etc/ssh/sshd_config > $config_path/ssh/sshd_config
sed "s/%PORT/$port/g" $base/etc/iptables.txt > $config_path/iptables.txt

if grep -q "precise" /etc/lsb-release; then
    echo "net.ipv4.netfilter.ip_conntrack_max=262144" >> $config_path/sysctl.conf
else
    echo "net.netfilter.nf_conntrack_max=262144" >> $config_path/sysctl.conf
fi

echo "net.ipv4.ip_local_port_range=10000 65535" >> $config_path/sysctl.conf
echo "$user ALL=NOPASSWD: ALL" > $config_path/sudoers.d/60_$user
chmod 440 $config_path/sudoers.d/60_$user

if [ "$op" = "install" ]; then
    adduser --disabled-password --gecos "" $user
    mkdir /home/$user/.ssh
    touch /home/$user/.ssh/authorized_keys
    chown -R "${user}:${user}" /home/$user/.ssh
    chmod 700 /home/$user/.ssh
    restart ssh
    modprobe ip_conntrack
    /sbin/sysctl -p
    iptables-restore < /etc/iptables.txt
fi
