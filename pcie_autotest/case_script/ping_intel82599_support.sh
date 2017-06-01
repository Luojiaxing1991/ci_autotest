#!/bin/bash

# run the ping function by Intel 82599 network card
# IN :N/A
# OUT:N/A
function support_ping_intel82599_test()
{
    Test_Case_Title="support_ping_intel82599_test"
    Test_Case_ID="ST.PERF.002/ST.PERF.003"
    ipl=("192.168.80.204" "192.168.90.204")
    ipg=("192.168.80.203" "192.168.90.203")
    ssh root@$BACK_IP 'ifconfig eth8 ${ipg[1]};ifconfig eth9 ${ipg[0]}'
    num=0
    for ethx in `ip a |grep "eth[0-9]\+:" |cut -d: -f2`
    do
        info=`ethtool -i ${ethx} |grep ixgbe`
        if [ x"$info" = x"" ]
        then
           continue
        fi
        echo "intel82599 network ports are ${ethx}."
        ifconfig ${ethx} up
        info=`ethtool ${ethx} |grep "Link detected: yes"`
        if [ x"$info" != x"" ]
        then
            ifconfig ${ethx} ${ipl[$num]}
            ping -I ${ethx} ${ipg[$num]} -w 120 >/dev/null
            if [ $? -ne 0 ]
            then
                echo "No, fail, ping intel82599 network ports about ${ethx} failed!"
                return
            fi

        let num+=1
        echo "Yes, scucceed, ping intel82599 network ports about ${ethx} successfully!"
        fi
    done
    writePass
}

function main()
{
    JIRA_ID="N/A"
    Test_Item="iperf_performance_D05_82599"
    Designed_Requirement_ID="NULL"

    support_ping_intel82599_test
}

main

