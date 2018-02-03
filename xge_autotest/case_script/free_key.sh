#!/bin/bash
cd /root/.ssh
/usr/bin/expect<<-EOF
spawn ssh-keygen -t rsa
expect "Enter file in which to save the key*:"
send "\r"
expect "Enter passphrase (empty for no passphrase):"
send "\r"
expect "Enter same passphrase again:"
send "\r"
expect eof
EOF
cp id_rsa.pub authorized_keys
scp authorized_keys root@192.168.1.239:/root/.ssh
cd ~

