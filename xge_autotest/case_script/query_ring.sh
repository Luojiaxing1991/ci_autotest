#!/bin/bash

# query ring parameter
# IN :N/A
# OUT:N/A
function ring_query()
{
    Test_Case_Title="query ring parameter"
    Test_Case_ID="ST_SGE_GET_RINGBD_000"
    :> D03ring.txt
	#D05flag=$(ssh root@$BACK_IP ':> D05ring.txt; ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up; for i in eth0 eth1 eth2 eth3; do ethtool -g $i | grep -Po "(?<=TX:|RX:)(.*)" | sed \'s/	//g\' | tr \'\n\' \' \'| sed \'s/ //g\' >> D05ring.txt; done; ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down; for i in eth0 eth1 eth2 eth3; do ethtool -g $i | grep -Po "(?<=TX:|RX:)(.*)" | sed \'s/	//g\' | tr \'\n\' \' \' | sed \'s/ //g\' >> D05ring.txt; done; ringvalue=`cat D05ring.txt | grep -w "1024102410241024"| wc -l`; if [ $ringvalue -eq 8 ];then D05flag=1;fi;echo $D05flag;')

    ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up
	for i in eth0 eth1 eth2 eth3
	do
	  ethtool -g $i | grep -Po "(?<=TX:|RX:)(.*)" | sed 's/	//g' | tr '\n' ' '| sed 's/ //g' >> D03ring.txt
    done
    ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down
	for i in eth0 eth1 eth2 eth3
	do
	  ethtool -g $i | grep -Po "(?<=TX:|RX:)(.*)" | sed 's/	//g' | tr '\n' ' ' | sed 's/ //g' >> D03ring.txt
    done
	ringvalue=$(cat D03ring.txt | grep -o "1024102410241024" | wc -l)
	if [ $ringvalue -eq 8 ]; then
	     D03flag=1;
	fi

    if [ "$D03flag" == "1" ]; then
	     writePass
	else
         writeFail
	fi

	rm -rf D03ring.txt
}

function main()
{
    JIRA_ID="PV-1509"
    Test_Item="support of ring parameter gettings"
    Designed_Requirement_ID="R.HNS.F029A"
	ring_query
}


main


