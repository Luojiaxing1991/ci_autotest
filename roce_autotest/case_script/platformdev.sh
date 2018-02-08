#!/bin/bash

#Verify rocee is platform device
#IN	:N/A
#OUT:N/A
function platformdev ()
{
	if [ -e /sys/devices/platform/HISI00D1\:00 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE="FAIL\tThe RoCEE does not exist!"
	fi
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}
main
