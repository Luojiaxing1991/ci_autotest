#!/bin/bash

# set rx flow hash configuration
# IN :N/A
# OUT:N/A
function rss()
{
   Test_Case_Title="set rx flow hash configuration"
   Test_Case_ID="ST_XGE_HKEY_000"
   :>rss.txt
   ifconfig eth2 up
   ifconfig eth2 192.168.7.212
   ethtool -X eth2 equal 16
   ethtool -X eth2 hkey 31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31
   ethtool -x eth2 > rss.txt
   hkeyvalue=$(cat rss.txt | tail -n 1)
   ringvalue=$(cat rss.txt | grep -w "15" | wc -l )
   if [ "$hkeyvalue" == "31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31:31" -a $ringvalue -eq 16 ];then
       writePass
   else
       writeFail
   fi

}

function main()
{
    JIRA_ID="PV-1503"
    Test_Item="set rx flow hash configuration"
    Designed_Requirement_ID="R.HNS.F021A"
    rss
}


main


