#!/bin/bash

#Support of XGE
#IN	:N/A
#OUT:N/A
function SupportXGE()
{
	ethtool $LOCAL_ETHX | grep "10000Mb/s" > /dev/null
	[ $? != 0 ] && MESSAGE="FAIL\tThe $LOCAL_ETHX on Server isn't XGE!" && return 1

	XGE_Flag=`ssh root@${BACK_IP} "ethtool $REMOTE_ETHX | grep -c '10000Mb/s'" `

	if [ $XGE_Flag != 1 ]
	then
		MESSAGE="FAIL\tThe $REMOTE_ETHX on Client isn't XGE!"
		return 1
	fi
}

function Send_On_XGE()
{
	SupportXGE
	[ $? != 0 ] && return 1

	pushd ${ROCE_CASE_DIR}/perftest/

	./ib_send_bw -i $ROCE_PORT > /dev/null 2>&1 &
	SendFlag=`ssh root@${BACK_IP} "./${CASEPATH}/ib_send_bw -i $ROCE_PORT ${local_port_ip[$ROCE_PORT]} | grep -c "65536" " `
	wait

	if [ $SendFlag == 1 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE= "FAIL\tsend on XGE port fail!"
	fi

	popd
}

function Read_On_XGE()
{
	SupportXGE
	[ $? != 0 ] && return 1

	pushd ${ROCE_CASE_DIR}/perftest/

	./ib_read_bw -i $ROCE_PORT > /dev/null 2>&1 &
	ReadFlag=`ssh root@${BACK_IP} "./${CASEPATH}/ib_read_bw -i $ROCE_PORT ${local_port_ip[$ROCE_PORT]} | grep -c "65536" " `
	wait

	if [ $ReadFlag == 1 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE= "FAIL\tread on XGE port fail!"
	fi

	popd
}

function Write_On_XGE()
{
	SupportXGE
	[ $? != 0 ] && return 1

	pushd ${ROCE_CASE_DIR}/perftest/

	./ib_write_bw -i $ROCE_PORT > /dev/null 2>&1 &
	WriteFlag=`ssh root@${BACK_IP} "./${CASEPATH}/ib_write_bw -i $ROCE_PORT ${local_port_ip[$ROCE_PORT]} | grep -c "65536" " `
	wait

	if [ $WriteFlag == 1 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE= "FAIL\twrite on XGE port fail!"
	fi

	popd
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}
main

