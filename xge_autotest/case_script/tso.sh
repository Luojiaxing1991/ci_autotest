#!/bin/bash

# support of tcp segment offload
# IN :N/A
# OUT:N/A
function tso()
{
    Test_Case_Title="tso function"
    Test_Case_ID="ST_SUPPORT_TSO_000"
    :>tcpdump.txt;:>length.txt
    ifconfig eth1 up; ifconfig eth1 192.168.100.212
    ethtool -K eth1 gro on
    killall iperf
    iperf -s &
    tcpdump -ei eth1 src 192.168.100.200 -c 103 > tcpdump.txt &
    ssh root@$BACK_IP ':>D05iperf.txt; ifconfig eth1 up; ifconfig eth1 192.168.100.200; ethtool -K eth1 gso off; ethtool -K eth1 tso on; iperf -c 192.168.100.212 -i 3 -t 33 > D05iperf.txt &'
    sleep 15
    sed -i '1,3d' tcpdump.txt
    cat tcpdump.txt | grep -Po "(?<=length )([0-9]*)(?=:)" > length.txt
    export count=0
    while read LINE
    do
      if [ $LINE -gt 16000 ];then
         ((count++))
      fi
    done < length.txt
    if [ $count -gt 60 ];then
      writePass
    else
      writeFail
    fi
    #percent=`printf "%d" $(($count*100/50))`
    #percent=`awk 'BEGIN{printf "%d\n",('$count'/50)*100}'`
    rm -rf tcpdump.txt
    rm -rf length.txt
}
function main()
{
    JIRA_ID="PV-1498"
    Test_Item="support of tso"
    Designed_Requirement_ID="R.HNS.F015A"
    tso
}


main


