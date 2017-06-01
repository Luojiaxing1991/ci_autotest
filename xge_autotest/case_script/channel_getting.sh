#!/bin/bash

# query channel parameters of each port
# IN :N/A
# OUT:N/A
function channel_getting()
{
    Test_Case_Title="query channel parameters of each port"
    Test_Case_ID="ST.SGE_GET_CHANNEL_000"
    :> D03channel.txt
    #D05flag=$(ssh root@$BACK_IP ':> D05channel.txt; ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up; for i in eth0 eth1 eth2 eth3; do ethtool -l $i | egrep 'RX|TX' | awk -F: '{print $2}' | tr '\n' ' ' | sed 's/	//g' | sed 's/ //g' >> D05channel.txt;done; ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down; for i in eth1 eth2 eth3; do ethtool -l $i | egrep 'RX|TX' | awk -F: '{print $2}' | tr '\n' ' ' | sed 's/	//g' | sed 's/ //g'` >> D05channel.txt;done; channelvalue=`cat D05channel.txt| grep -w "16161616" | wc -l`; if [ "$channelvalue" == "7" ];then D05flag=1;fi;echo D05flag;')
	#for i in 0 1 2 3
	#do
    #    eth$iup=`ethtool -l eth$i | egrep 'RX|TX' | awk -F: '{print $2}' | tr '\n' ' ' | sed 's/   //g' | sed 's/ //g'`
	#done
    ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up
	for i in eth0 eth1 eth2 eth3
	do
	 ethtool -l $i | egrep 'RX|TX' | awk -F: '{print $2}' | tr '\n' ' ' | sed 's/	//g' | sed 's/ //g' >> D03channel.txt
    done
    ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down
	for i in eth0 eth1 eth2 eth3
	do
     ethtool -l $i | egrep 'RX|TX' | awk -F: '{print $2}' | tr '\n' ' ' | sed 's/	//g' | sed 's/ //g' >> D03channel.txt
    done

	channelvalue=$(cat D03channel.txt | grep -o "16161616"| wc -l)
    if [ "$channelvalue" == "8" ];then
         D03flag=1;
    fi
	rm -rf D03channel.txt
    if [ "$D03flag" == "1" ];then
       writePass
    else
       writeFail
    fi
}

    #if [ "$eth0" = "1111" -a "$eth1up" = "1111" -a "$eth1down" = "1111" -a "$eth2up" = "16161616" -a "$eth2down" = "16161616" -a "$eth3up" = "16161616" -a  "$eth3down" = "16161616" ];then
	#	writePass
	#else
	#	writeFail
	#fi
	function main()
	{
      JIRA_ID="PV-1513"
	  Test_Item="support of channel gettings"
	  Designed_Requirement_ID="R.HNS.F033A"
	  channel_getting
	}
    main
