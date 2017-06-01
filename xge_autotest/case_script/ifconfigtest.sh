#!/bin/bash

# getting base information
# IN :N/A
# OUT:N/A
function ifconfigtest()
{
   Test_Case_Title="ifconfig get base information"
   Test_Case_ID="ST_SHNS_BASE_INFORMATION_000"
   :> D03ifconfig.txt

   #D05flag=$(ssh root@$BACK_IP ':> D05portstatus.txt; ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up; sleep 20; for i in eth0 eth1 eth2 eth3; do ethtool $i  >> D05portstatus.txt; done; linkvalue=`cat D05portstatus.txt | grep "Link detected" | cut -d : -f2 | wc -l`;GEspeedvalue=`cat D05portstatus.txt | grep "Twisted Pair" -B 3 | grep "1000Mb/s"| wc -l`;XGEspeedvalue=`cat D05portstatus.txt | grep "Port: FIBRE" -B 3 | grep "10000Mb/s"| wc -l`; if [ $linkvalue -eq 4 -a $GEspeedvalue -eq 2 -a $XGEspeedvalue -eq 2 ];then D05flag=1;fi; echo $D05flag ; rm -rf D05portstatus.txt')

   ifconfig eth1 up
   ifconfig eth2 up
   ifconfig eth3 up

   for i in eth0 eth1 eth2 eth3
   do
       ifconfig $i >> D03ifconfig.txt
   done
   noerrorcount=`cat D03ifconfig.txt | grep "RX packets:" | grep -o "errors:0" | wc -l`
   nodropcount=`cat D03ifconfig.txt | grep "RX packets:" | grep -o "dropped:0" | wc -l`
   if [ $noerrorcount -eq 4 -a $nodropcount -eq 4 ];then
      D03flag=1;
   fi

   if [ $D03flag -eq 1 ];then
	     writePass
   else
         writeFail
   fi
   rm -rf D03ifconfig.txt
}

function main()
{
    JIRA_ID="PV-1495"
    Test_Item="getting base information"
    Designed_Requirement_ID="R.HNS.F012A"
    ifconfigtest
}

main


