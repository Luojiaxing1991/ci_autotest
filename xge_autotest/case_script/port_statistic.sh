#!/bin/bash

# port status info
# IN :N/A
# OUT:N/A
function port_statistic()
{
    Test_Case_Title="query GE interface statistics after HNS information"
    Test_Case_ID="ST_ETHTOOL_GET_STATS_000"
    killall iperf
    sleep 20
    :> D03portstatistic.txt
    ifconfig eth1 up; ifconfig eth1 192.168.100.212
    iperf -s &
    ssh root@$BACK_IP ':>D05iperf.txt; ifconfig eth1 up; ifconfig eth1 192.168.100.200;iperf -c 192.168.100.212 -i 3 -t 30 > D05iperf.txt &'
    sleep 10
    ethtool -S eth1 >D03portstatistic.txt
    rx_error=`cat D03portstatistic.txt | grep -Po "(?<=rx_errors: )([0-9]*)"`
    tx_error=`cat D03portstatistic.txt | grep -Po "(?<=tx_errors: )([0-9]*)"`
    rx_drop=`cat D03portstatistic.txt | grep -w "rx_dropped" |grep -Po "(?<=rx_dropped: )([0-9]*)"`
    tx_drop=`cat D03portstatistic.txt |grep -w "tx_dropped" | grep -Po "(?<=tx_dropped: )([0-9]*)"`

    if [ $rx_error -eq 0 -a $tx_error -eq 0 -a $rx_drop -eq 0 -a $tx_drop -eq 0 ];then
       writePass
    else
       writeFail
    fi

}

function main()
{
    JIRA_ID="PV-1510"
    Test_Item="support of getting interface statistics through ethtool"
    Designed_Requirement_ID="R.HNS.F031A"
    port_statistic
}


main


