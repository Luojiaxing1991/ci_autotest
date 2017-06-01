#!/bin/bash

# set checksum offload
# IN :N/A
# OUT:N/A
function checksum_offload()
{
   Test_Case_Title="set checksum offload(TX/RX)"
   Test_Case_ID="ST_XGE_CHECKSUM_OFFLOAD_000"
   :> D03checksum.txt
   for i in eth0 eth1 eth2 eth3
   do
	ethtool -K $i rx on tx on
	ethtool -k $i | head -n 8 >> D03checksum.txt
	ethtool -K $i rx off tx off
	ethtool -k $i | head -n 8 >> D03checksum.txt
   done
   rxonvalue=$(cat D03checksum.txt | grep "rx-checksumming: on" | wc -l)
   txonvalue=$(cat D03checksum.txt | grep "tx-checksumming: on" | wc -l)
   rxoffvalue=$(cat D03checksum.txt | grep "rx-checksumming: off" | wc -l)
   txoffvalue=$(cat D03checksum.txt | grep "tx-checksumming: off" | wc -l)
   if [ $rxonvalue -eq 4 -a $txonvalue -eq 4 -a $rxoffvalue -eq 4 -a $txoffvalue -eq 4 ];then
      D03flag=1;
   fi

   if [ $D03flag -eq 1 ];then
	     writePass
   else
         writeFail
   fi

}

function main()
{
    JIRA_ID="PV-1502"
    Test_Item="checksum offload"
    Designed_Requirement_ID="R.HNS.F020A"
	checksum_offload
}


main


