#!/bin/bash
# query dump registers
# IN :N/A
# OUT:N/A
function dump_register()
{
    Test_Case_Title="support to dump registers"
    Test_Case_ID="ST.GE/XGE_GET_REGS_000"
    #ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up'
    ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up
    eth0=`ethtool -d eth0 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    eth1up=`ethtool -d eth1 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    eth2up=`ethtool -d eth2 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    eth3up=`ethtool -d eth3 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    #ssh root@$BACK_IP 'ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down'
    ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down
    eth1down=`ethtool -d eth1 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    eth2down=`ethtool -d eth2 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    eth3down=`ethtool -d eth3 | tail -n 1 | awk -F: '{print $2}' | sed 's/	//g' | sed 's/ //g'`
    if [ "$eth0" = "dddddddddddddddddddddddddddddddd" -a "$eth1up" = "dddddddddddddddddddddddddddddddd" -a  "$eth1down" = "dddddddddddddddddddddddddddddddd" -a "$eth2up" = "dddddddddddddddd" -a "$eth2down" = "dddddddddddddddd" -a "$eth3up" = "dddddddddddddddd" -a "$eth2down" = "dddddddddddddddd" ];then 
        writePass
    else
        writeFail
    fi
}

function main()
{
    JIRA_ID="PV-1518"
    Test_Item="support to dump registers"
    Designed_Requirement_ID="R.HNS.R027A"
    dump_register
}


main


