#!/bin/bash

# port status info
# IN :N/A
# OUT:N/A
function port_status_query()
{
   Test_Case_Title="GE/XGE ports' basic configuration query"
   Test_Case_ID="ST_GE_GET_SETTINGS_000/ST_XGE_GET_SETTINGS_005"
   :> D03portstatus.txt
   ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up;

   D05flag=$(ssh root@$BACK_IP ':> D05portstatus.txt; ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up; sleep 20; for i in eth0 eth1 eth2 eth3; do ethtool $i  >> D05portstatus.txt; done; linkvalue=`cat D05portstatus.txt | grep "Link detected" | cut -d : -f2 | wc -l`;GEspeedvalue=`cat D05portstatus.txt | grep "Twisted Pair" -B 3 | grep "1000Mb/s"| wc -l`;XGEspeedvalue=`cat D05portstatus.txt | grep "Port: FIBRE" -B 3 | grep "10000Mb/s"| wc -l`; if [ $linkvalue -eq 4 -a $GEspeedvalue -eq 2 -a $XGEspeedvalue -eq 2 ];then D05flag=1;fi; echo $D05flag ; rm -rf D05portstatus.txt')

   for i in eth0 eth1 eth2 eth3
   do
	ethtool $i  >> D03portstatus.txt
   done
   linkvalue=`cat D03portstatus.txt | grep "Link detected" | cut -d : -f2 | wc -l`
   GEspeedvalue=`cat D03portstatus.txt | grep "Twisted Pair" -B 3 | grep "1000Mb/s"| wc -l`
   XGEspeedvalue=`cat D03portstatus.txt | grep "Port: FIBRE" -B 3 | grep "10000Mb/s"| wc -l`
   if [ $linkvalue -eq 4 -a $GEspeedvalue -eq 2 -a $XGEspeedvalue -eq 2 ];then
      D03flag=1;
   fi

   if [ $D03flag -eq 1 -a $D05flag -eq 1 ];then
	     writePass
   else
         writeFail
   fi

}

function main()
{
    JIRA_ID="PV-1506"
    Test_Item="support to query port status"
    Designed_Requirement_ID="R.HNS.F026A"
	port_status_query
}


main


