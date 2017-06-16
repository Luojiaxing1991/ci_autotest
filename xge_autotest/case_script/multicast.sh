#!/bin/bash

# multicast traffic support
# IN :N/A
# OUT:N/A
function multicast()
{
    Test_Case_Title="use the omping tool to test multicast"
    Test_Case_ID="ST_XGE_MULTICAST_004"
    :> D03omping.txt
    ifconfig eth1 up
    ifconfig eth1 192.168.100.212
    ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth1 192.168.100.200; sleep 10; omping 192.168.100.200 192.168.100.212 -m 232.43.211.23 -c 10 > D05omping.txt &'
    sleep 20
    omping 192.168.100.200 192.168.100.212 -m 232.43.211.23 -c 10 > D03omping.txt &
    sleep 20
    cat D03omping.txt | grep "192.168.100.200 :   unicast" -A 1 | grep "192.168.100.200 : multicast" >/dev/null 
    if [ $? -eq 0 ];then
       D03flag=1
     fi
    if [ $D03flag -eq 1 ];then
       writePass
    else
       writeFail
    fi

}

function main()
{
    JIRA_ID="PV-1489"
    Test_Item="multicast traffic support"
    Designed_Requirement_ID="R.HNS.F004A"
    multicast
}


main


