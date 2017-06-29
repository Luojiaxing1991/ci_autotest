#!/bin/bash

# GE/XGE self test
# IN :N/A
# OUT:N/A
function self_test()
{
    Test_Case_Title="self_test function normally"
    Test_Case_ID="ST.GE_SELF_TEST_000"
    #ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up'
    ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up
    tmpup=`ethtool -t eth0 | grep PASS && ethtool -t eth1 | grep PASS  && ethtool -t eth2 | grep PASS  && ethtool -t eth3 | grep PASS`
    upresult=`echo "$tmpup" | grep -o "PASS" | wc -l`
    #ssh root@$BACK_IP 'ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down'
    ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down
    tmpdown=`ethtool -t eth0 | grep PASS && ethtool -t eth1 | grep PASS && ethtool -t eth2 | grep PASS && ethtool -t eth3 | grep PASS`
    downresult=`echo "$tmpdown" | grep -o "PASS" | wc -l`
    if [ $upresult -eq 4 -a $downresult -eq 4 ];then 
       writePass
    else
       writeFail
    fi
}

function main()
{
    JIRA_ID="PV-1511"
    Test_Item="GE/XGE self test"
    Designed_Requirement_ID="R.HNS.F032A"
    self_test
}


main


