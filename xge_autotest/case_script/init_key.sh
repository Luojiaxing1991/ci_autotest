#!/bin/bash
ls /root/.ssh | grep "id_*"
if [ $? eq 0 ]
    rm /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
    rm /rrot/.ssh/authorized_keys
