#!/bin/bash

#Configure  GID according to IP
#IN	:N/A
#OUT:N/A
function gid-ip()
{
	local roceip=`ifconfig eth3 | grep -Po "(?<=(inet addr:))(.*)(?=(  Bcast))"`
	local gid7=`cat /sys/class/infiniband/hns_0/ports/2/gids/1 | awk -F ':' '{print $7}'`
	local gid8=`cat /sys/class/infiniband/hns_0/ports/2/gids/1 | awk -F ':' '{print $8}'`

	local ip1=`printf %02x $(echo $roceip | awk -F '.' '{print $1}')`
	local ip2=`printf %02x $(echo $roceip | awk -F '.' '{print $2}')`
	local ip3=`printf %02x $(echo $roceip | awk -F '.' '{print $3}')`
	local ip4=`printf %02x $(echo $roceip | awk -F '.' '{print $4}')`

	if [ $gid7 == ${ip1}${ip2} -a $gid8 == ${ip3}${ip4} ]
	then
		MESSAGE="PASS"
	else
		MESSAGE="FAIL\tConfigure GID according to IP failed, please check!"
	fi
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}

main
