#!/bin/bash

#The maximum number of USR's MR is 512*1024
#IN :N/A
#OUT:N/A
function Max_USR_MR_512k()
{
	Test_Case_ID="ST-ROCE-71"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 17 -e 17 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 17 -e 17 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify the max number of USR's MR successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify the max number of USR's MR failed, please check!!!"
	fi

	popd

	return 0
}

#The maximum number of DMA's MR is 512*1024
#IN :N/A
#OUT:N/A
function Max_DMA_MR_512k()
{
	Test_Case_ID="ST-ROCE-72"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 28 -e 28 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 28 -e 28 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify the max number of DMA's MR successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify the max number of DMA's MR failed, please check!!!"
	fi

	popd

	return 0
}

#Register DMA's MR with 2G size
#IN	:N/A
#OUT:N/A
function DMA_MR_2G()
{
	Test_Case_ID="ST-ROCE-67"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 18 -e 18 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 18 -e 18 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Register DMA's MR with 2G size successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Register DMA's MR with 2G size failed, please check!!!"
	fi

	popd

	return 0
}

#Register USR's MR with 2G size
#IN :N/A
#OUT:N/A
function USR_MR_2G()
{
	Test_Case_ID="ST-ROCE-68"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 19 -e 19 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 19 -e 19 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Register USR's MR with 2G size successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Register USR's MR with 2G size failed, please check!!!"
	fi

	popd

	return 0
}

#Register MR with remote write access
#IN :N/A
#OUT:N/A
function MR_Remote_Write()
{
	Test_Case_ID="ST-ROCE-73"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 22 -e 22 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 22 -e 22 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Register MR with remote write access successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Register MR with remote write access failed, please check!!!"
	fi

	popd

	return 0
}

#Register MR with remote read and local write access
#IN :N/A
#OUT:N/A
function MR_Remote_Read_Local Write()
{
	Test_Case_ID="ST-ROCE-74"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 23 -e 23 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 23 -e 23 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Register MR with remote read and local write access successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Register MR with remote read and local write access failed, please check!!!"
	fi

	popd

	return 0
}

function main()
{
	JIRA_ID="PV-353"
	Designed_Requirement_ID="R.ROCE.F025.A"
	Test_Item="Support of MR"
	Test_Case_Title=""

	DMA_MR_2G

	USR_MR_2G

	#Max_USR_MR_512k

	#Max_DMA_MR_512k

	MR_Remote_Write

	MR_Remote_Read_Local Write
}
main

