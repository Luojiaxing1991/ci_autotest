#!/bin/bash

#Configure  GID according to MAC
#IN	:N/A
#OUT:N/A
function gid-mac()
{
	local gid7=`cat /sys/class/infiniband/hns_0/ports/${ROCE_PORT}/gids/0 | awk -F ':' '{print $7}' | cut -c3-`
	local gid8=`cat /sys/class/infiniband/hns_0/ports/${ROCE_PORT}/gids/0 | awk -F ':' '{print $8}'`

	local hwaddr=`ifconfig $LOCAL_ETHX | grep -Po "(?<=(HWaddr ))(.*)(?=(  ))"`
	local mac4=`echo $hwaddr | awk -F ':' '{print $(NF-2)}'`
	local mac5=`echo $hwaddr | awk -F ':' '{print $(NF-1)}'`
	local mac6=`echo $hwaddr | awk -F ':' '{print $NF}'`

	if [ $gid7 == $mac4 -a $gid8 == $mac5$mac6 ]
	then
		MESSAGE="PASS"
		writePass "Configure  GID according to MAC successfully."
	else
		MESSAGE="FAIL\tConfigure  GID according to MAC failed, please check!"
	fi
	echo ${MESSAGE}
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}

main

