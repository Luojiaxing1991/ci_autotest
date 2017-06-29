#!/bin/bash

# 24 hours iperf test
# IN :N/A
# OUT:N/A
function 24_hours_iperf_test()
{
    Test_Case_Title="check CPU usage when run high traffic"
    Test_Case_ID="ST.SHNS_THROUGHPUT_000"
    :>24htest.txt
    ifconfig eth1 up; ifconfig eth1 192.168.100.212
    ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth1 192.168.100.200; iperf -s > iperf.txt & '
    sleep 20
    #iperf -c 192.168.100.200 -i 10 -t 86400 > 24htest.txt &
    iperf -c 192.168.100.200 -i 10 -t 86400 > 24htest.txt &
    sleep 3600
    cpu_usage=$(top -b -n 1 -p `pgrep iperf | tr "\\n" "," | sed 's/,$//'` | tail -n 1 | awk '{print $9}')
    result1=$(echo "$cpu_usage > 300"|bc)
    sleep 3600
    cpu_usage=$(top -b -n 1 -p `pgrep iperf | tr "\\n" "," | sed 's/,$//'` | tail -n 1 | awk '{print $9}')
    result2=$(echo "$cpu_usage > 300"|bc)
    if [ $result1 -eq 0 -a $result2 -eq 0 ];then
         writePass
    else
         writeFail
    fi

    rm -rf 24htest.txt
}

function main()
{
    JIRA_ID="PV-942"
    Test_Item="CPU usage requirement"
    Designed_Requirement_ID="R.HNS.P002B"
    24_hours_iperf_test
}
main


