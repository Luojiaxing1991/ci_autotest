#!/bin/bash

# enable and disable interface
# IN :N/A
# OUT:N/A
function enable_and_disable_interface()
{
    Test_Case_Title="enable and disable GE ports"
    Test_Case_ID="ST_GE_PORT_CTRL_000"
    :>D03ping.txt
    ifconfig eth1 up; ifconfig eth1 192.168.100.212
    ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth1 192.168.100.200; sleep 10;'
    ping 192.168.100.200 -c 5 > D03ping.txt &
    sleep 10
    cat D03ping.txt | grep "0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       enableok=1
    fi
    ssh root@$BACK_IP 'ifconfig eth1 down;'
    ping 192.168.100.200 -c 5 > D03ping.txt &
    sleep 10
    cat D03ping.txt | grep "0% packet loss" >/dev/null
    if [ $? -eq 1 ];then
       disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        writePass
    else
        writeFail
    fi
    rm -f D03ping.txt
}

function main()
{
    JIRA_ID="PV-1488"
    Test_Item="enable and disable of interface"
    Designed_Requirement_ID="R.HNS.F001A"
    enable_and_disable_interface
}


main


