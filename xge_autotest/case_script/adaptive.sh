#!/bin/bash

# adaptive interrupt moderation support
# IN :N/A
# OUT:N/A
function adaptive()
{
   Test_Case_Title="adapt coalesce according to flow rate"
   Test_Case_ID="ST_SHNS_ADAPTIVE_COALESCE_000"
   ifconfig eth2 up
   ifconfig eth2 192.168.7.212
   ethtool -C eth2 adaptive-rx on adaptive-tx on
   rxusecsinit=$(ethtool -c eth2 | grep -Po "(?<=rx-usecs: )([0-9]*)")
   rxframesinit=$(ethtool -c eth2 | grep -Po "(?<=rx-frames: )([0-9]*)")
   txusecsinit=$(ethtool -c eth2 | grep -Po "(?<=tx-usecs: )([0-9]*)")
   txframesinit=$(ethtool -c eth2 | grep -Po "(?<=tx-frames: )([0-9]*)")
   iperf -s &
   ssh root@$BACK_IP 'ifconfig eth2 up; ifconfig eth2 192.168.7.200;sleep 10; iperf -c 192.168.7.212 -i 3 -t 30;sleep 20;'
   sleep 20
   rxusecs=$(ethtool -c eth2 | grep -Po "(?<=rx-usecs: )([0-9]*)")
   rxframes=$(ethtool -c eth2 | grep -Po "(?<=rx-frames: )([0-9]*)")
   txusecs=$(ethtool -c eth2 | grep -Po "(?<=tx-usecs: )([0-9]*)")
   txframes=$(ethtool -c eth2 | grep -Po "(?<=tx-frames: )([0-9]*)")
   rxusecsdiff=`expr $rxusecs - $rxusecsinit`
   rxframesdiff=`expr $rxframes - $rxframesinit`
   txusecsdiff=`expr $txusecs - $txusecsinit`
   txframesdiff=`expr $txframes - $txframesinit`
   killall iperf
   if [ $rxusecsdiff -ne 0 -o $rxframesdiff -ne 0 -a $txusecsdiff -ne 0 -a $txframesdiff -eq 0 ];then
	     writePass
   else
         writeFail
   fi

}

function main()
{
    JIRA_ID="PV-1500"
    Test_Item="adaptive interrupt moderation support"
    Designed_Requirement_ID="R.HNS.F018A"
	adaptive
}


main


