#!/bin/bash

#Configure  GID according to MAC
#IN	:N/A
#OUT:N/A
function gid-mac()
{
	local gid7=`cat /sys/class/infiniband/hns_0/ports/2/gids/0 | awk -F ':' '{print $7}' | cut -c3-`
	local gid8=`cat /sys/class/infiniband/hns_0/ports/2/gids/0 | awk -F ':' '{print $8}'`

	local hwaddr=`ifconfig eth3 | grep -Po "(?<=(HWaddr ))(.*)(?=(  ))"`
	local mac4=`echo $hwaddr | awk -F ':' '{print $(NF-2)}'`
	local mac5=`echo $hwaddr | awk -F ':' '{print $(NF-1)}'`
	local mac6=`echo $hwaddr | awk -F ':' '{print $NF}'`

	if [ $gid7 == $mac4 -a $gid8 == $mac5$mac6 ]
	then
		writePass "Configure  GID according to MAC successfully."
	else
		writeFail "Configure  GID according to MAC failed, please check!!!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-287"
	Designed_Requirement_ID="R.ROCE.F010.A"
	Test_Case_ID="ST-ROCE-78"
	Test_Item="Configure  GID according to MAC"
	Test_Case_Title=""
	
	gid-mac
}

main

