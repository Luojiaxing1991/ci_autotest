#!/bin/bash

# Ping6 XGE test
# IN :N/A
# OUT:N/A
function ping6_XGE_test()
{
    Test_Case_Title="XGE support to IPV6"
    Test_Case_ID="ST.FUNC.049/ST.FUNC.050"
    IPV6=$(ssh root@$BACK_IP 'ifconfig eth3 up; sleep 10; ifconfig -a | grep "eth3" -A 4 | grep "inet6 addr" |  grep -Po "(?<=: )([^/]*)"')
    #IPV6=$(ssh root@$BACK_IP 'ifconfig eth3 up; ifconfig eth3; ifconfig -a | grep "eth3" -A 4 ')
    ping6 $IPV6%eth3 -c 5 >ping6_XGE.txt &
    sleep 15
    cat ping6_XGE.txt | grep "0% packet loss"
    result=`echo $?`
    if [ "$result" -eq 0 ];then 
		writePass
    else
		writeFail
    fi
    rm -f ping6_XGE.txt
}

function main()
{
    JIRA_ID="PV-1496"
    Test_Item="IPV6 testing"
    Designed_Requirement_ID="R.HNS.F013A"
    ping6_XGE_test
}


main


