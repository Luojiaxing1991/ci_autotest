#!/bin/bash

#load roce's kernel driver
#IN	:N/A
#OUT:N/A
function Load_kernel_driver()
{
	if [ -d /sys/class/infiniband/hns_0 ]
	then
		MESSAGE="PASS\tThe kernel driver already exists"
		return 0
	fi

	insmod hns-roce.ko > ${FUNCNAME}.log
	[ $? != 0 ] && MESSAGE="FAIL\tinsmod hns-roce.ko failed" && return 1

	insmod hns-roce-hw-v1.ko >> ${FUNCNAME}.log
	[ $? != 0 ] && MESSAGE="FAIL\tinsmod hns-roce-hw-v1.ko failed" && return 1

	if [ -d /sys/class/infiniband/hns_0 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE="FAIL\tregister the RoCE's devices failed, please check ${FUNCNAME}.log"
	fi
}

#unload roce's kernel driver
#IN :N/A
#OUT:N/A
function Unload_kernel_driver()
{
	lsmod > ${FUNCNAME}.log
	grep -w "hns_roce_hw_v1" ${FUNCNAME}.log
	[ $? != 0 ] && MESSAGE="BLOCK\tModule hns_roce_hw_v1 is not currently loaded" && return 1

	rmmod hns-roce-hw-v1.ko >> ${FUNCNAME}.log
	[ $? != 0 ] && MESSAGE="FAIL\trmmod hns-roce-hw-v1.ko failed, please check log" && return 1

	grep -w "hns_roce" ${FUNCNAME}.log
	[ $? != 0 ] && MESSAGE="BLOCK\tModule hns_roce is not currently loaded" && return 1

	rmmod hns-roce.ko >> ${FUNCNAME}.log
	[ $? != 0 ] && MESSAGE="FAIL\trmmod hns-roce.ko failed, please check log" && return 1

	if [ ! -d /sys/class/infiniband/hns_0 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE="FAIL\tUnload RoCE's kernel driver failed, please check ${FUNCNAME}.log"
	fi

}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}

main
