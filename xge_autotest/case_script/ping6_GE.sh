#!/bin/bash

# Ping6 GE test
# IN :N/A
# OUT:N/A
function ping6_GE_test()
{
    Test_Case_Title="GE support to IPV6"
    Test_Case_ID="ST.FUNC.049/ST.FUNC.050"
    IPV6=$(ssh root@$BACK_IP 'ifconfig -a | grep "eth0" -A 2 | grep "inet6 addr" |  grep -Po "(?<=: )([^/]*)"')
    ping6 $IPV6%eth0 -c 5 >ping6_GE.txt &
    sleep 15
    cat ping6_GE.txt | grep "0% packet loss"
    result=`echo $?`
    if [ "$result" -eq 0 ];then 
		writePass
    else
		writeFail
    fi
    rm -f ping6_GE.txt
}

function main()
{
    JIRA_ID="PV-1496"
    Test_Item="IPV6 testing"
    Designed_Requirement_ID="R.HNS.F013A"
    ping6_GE_test
}


main


