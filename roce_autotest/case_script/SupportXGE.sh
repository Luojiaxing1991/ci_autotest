#!/bin/bash

#Support of XGE
#IN	:N/A
#OUT:N/A
function SupportXGE()
{
	local HOSTIP=`ifconfig eth3|grep -Po "(?<=(inet addr:))(.*)(?=(Bcast))"`
	ethtool eth3 | grep "10000Mb/s" > /dev/null
	[ $? != 0 ] && writeFail "The eth3 on Server isn't XGE!" && return 1

	ssh root@${BACK_IP} "ethtool eth3 > ${FUNCNAME}_client.log"
	scp root@${BACK_IP}:${FUNCNAME}_client.log ./

	grep "10000Mb/s" ${FUNCNAME}_client.log > /dev/null
	[ $? != 0 ] && writeFail "The eth3 on Client isn't XGE!" && return 1

	#echo "send on XGE port"
	./${TEST_CASE_PATH}/perftest/ib_send_bw -i 2 > /dev/null 2>&1 &
	SendFlag=`ssh root@${BACK_IP} "./${CASEPATH}/ib_send_bw -i 2 ${HOSTIP} | grep -c "65536" " `
	if [ $SendFlag == 1 ]
	then 
		writePass "send on XGE port OK!"
	else
		writeFail "send on XGE port fail!"		
	fi

	#echo "RDMA read on XGE port"
	./${TEST_CASE_PATH}/perftest/ib_read_bw -i 2 > /dev/null 2>&1 &
	ReadFlag=`ssh root@${BACK_IP} "./${CASEPATH}/ib_read_bw -i 2 ${HOSTIP} | grep -c "65536" " `
	if [ $ReadFlag == 1 ]
	then 
		writePass "read on XGE port OK!"
	else
		writeFail "read on XGE port fail!"
	fi

	#echo "RDMA write on XGE port"
	./${TEST_CASE_PATH}/perftest/ib_write_bw -i 2 > /dev/null 2>&1 &
	WriteFlag=`ssh root@${BACK_IP} "./${CASEPATH}/ib_write_bw -i 2 ${HOSTIP} | grep -c "65536" " `
	if [ $WriteFlag == 1 ]
	then 
		writePass "write on XGE port OK!"
	else
		writeFail "write on XGE port fail!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-1482"
	Designed_Requirement_ID="R.ROCE.F030.A"
	Test_Case_ID="ST-ROCE-89/90/91"
	Test_Item="Support of XGE"
	Test_Case_Title=""

	SupportXGE
}
main

