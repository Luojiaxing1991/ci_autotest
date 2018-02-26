#!/bin/bash

#The maximum number of USR's MR is 512*1024
#IN :N/A
#OUT:N/A
function Max_USR_MR_512k()
{
	pushd ${ROCE_CASE_DIR}

	${ROCE_TOP_DIR}/case_script/roce-test -m 2 -s 17 -e 17 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 17 -e 17 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\t Verify the max number of USR's MR failed, please check log!"
	fi

	popd
}

#The maximum number of DMA's MR is 512*1024
#IN :N/A
#OUT:N/A
function Max_DMA_MR_512k()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 28 -e 28 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 28 -e 28 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\t Verify the max number of DMA's MR failed, please check log!"
	fi

	popd
}

#Register DMA's MR with 2G size
#IN	:N/A
#OUT:N/A
function DMA_MR_2G()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 18 -e 18 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 18 -e 18 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tRegister DMA's MR with 2G size failed, please check log!"
	fi

	popd
}

#Register USR's MR with 2G size
#IN :N/A
#OUT:N/A
function USR_MR_2G()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 19 -e 19 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 19 -e 19 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tRegister USR's MR with 2G size failed, please check log!"
	fi

	popd
}

#Register MR with remote write access
#IN :N/A
#OUT:N/A
function MR_Remote_Write()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 22 -e 22 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 22 -e 22 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_${CASEPATH}/client.log log_00*"
	else
		MESSAGE="FAIL\tRegister MR with remote write access failed, please check log!"
	fi

	popd
}

#Register MR with remote read and local write access
#IN :N/A
#OUT:N/A
function MR_Remote_Read_Local_Write()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 23 -e 23 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &

	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 23 -e 23 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tRegister MR with remote read and local write access failed, please check log!"
	fi

	popd
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}
main

