#!/bin/bash

#load and unload roce's kernel driver
#IN	:N/A
#OUT:N/A
function Load_Unload_kernel_driver()
{
	Test_Case_ID="ST-ROCE-87"
	Test_Case_Title="Load the RoCE's kernel driver"
	insmod hns-roce.ko > ${FUNCNAME}.log
	if [ $? != 0 ]
	then
		writeFail "insmod hns-roce.ko failed, please check !"
		return 1
	fi

	insmod hns-roce-hw-v1.ko >> ${FUNCNAME}.log
	if [ $? != 0 ]
	then
		writeFail "insmod hns-roce-hw-v1.ko failed, please check !"
		return 1
	fi

	if [ -d /sys/class/infiniband/hns_0 ]
	then
		writePass "Load RoCE's kernel driver successfully"
	else
		writeFail "Load RoCE's kernel driver failed, please check ${FUNCNAME}.log"
		return 1
	fi

	Test_Case_ID="ST-ROCE-88"
	Test_Case_Title="Unload the RoCE's kernel driver"
	rmmod hns-roce-hw-v1.ko >> ${FUNCNAME}.log
	if [ $? != 0 ]
	then
		writeFail "rmmod hns-roce-hw-v1.ko failed, please check !"
		return 1
	fi

	rmmod hns-roce.ko >> ${FUNCNAME}.log
	if [ $? != 0 ]
	then
		writeFail "rmmod hns-roce.ko failed, please check !"
		return 1
	fi

	if [ ! -d /sys/class/infiniband/hns_0 ]
	then
		writePass "Unload RoCE's kernel driver successfully"
	else
		writeFail "Unload RoCE's kernel driver failed, please check ${FUNCNAME}.log"
		return 1
	fi

	return 0
}

function main()
{
	JIRA_ID=""
	Designed_Requirement_ID=""
	Test_Case_ID=""
	Test_Item="Verify load/remove the RoCE's kernel driver "
	Test_Case_Title=""
	Load_Unload_kernel_driver
}

main
