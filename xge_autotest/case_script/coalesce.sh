#!/bin/bash

# interrupt coalesce support
# IN :N/A
# OUT:N/A
function coalesce()
{
   Test_Case_Title="set waterline and time of interrupt coalesce"
   Test_Case_ID="ST_SHNS_COALESCE_000"
   :>coalesce.txt
   ifconfig eth2 up
   ifconfig eth2 192.168.7.212
   ethtool -C eth2 tx-usecs 1023 rx-usecs 1023
   ethtool -C eth2 tx-frames 1 rx-frames 1023
   tx_usecs=$(ethtool -c eth2 | grep -Po "(?<=tx-usecs: )([0-9]*)")
   rx_usecs=$(ethtool -c eth2 | grep -Po "(?<=rx-usecs: )([0-9]*)")
   tx_frames=$(ethtool -c eth2 | grep -Po "(?<=tx-frames: )([0-9]*)")
   rx_frames=$(ethtool -c eth2 | grep -Po "(?<=rx-frames: )([0-9]*)")
   if [ $tx_usecs -eq 1023 -a $rx_usecs -eq 1023 -a $tx_frames -eq 1 -a $rx_frames -eq 1023 ];then
       setflag=1
   fi
   ethtool -C eth2 tx-usecs 1024 rx-usecs 1024 2>>coalesce.txt
   ethtool -C eth2 tx-frames 1024 rx-frames 1024 2>> coalesce.txt
   cannotsetflag=`cat coalesce.txt | grep -o "Cannot set" | wc -l`

   if [ $setflag -eq 1 -a $cannotsetflag -eq 2 ];then
       writePass
   else
       writeFail
   fi

   ethtool -C eth2 tx-usecs 30 rx-usecs 30
   ethtool -C eth2 tx-frames 1 rx-frames 50
}

function main()
{
    JIRA_ID="PV-1501"
    Test_Item="interrupt coalesce support"
    Designed_Requirement_ID="R.HNS.F019A"
    coalesce
}


main


