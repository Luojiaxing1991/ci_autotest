#!/bin/bash

#Support of RDMA Write operation.
#IN	:N/A
#OUT:N/A
function RdmaWrite_MTU()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 8 -e 8 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 8 -e 8 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify RDMA write with MTU length failed, please check!"
	fi

	popd
}

function RdmaWrite_Gt_MTU()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 9 -e 9 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 9 -e 9 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify RDMA write with the length which is greater than MTU and less than 2MTU failed, please check!"
	fi

	popd
}

function RdmaWrite_Gt_2MTU()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 10 -e 10 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 10 -e 10 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify RDMA write with the length which is greater than 2MTU and less than 3MTU failed, please check!"
	fi

	popd
}

function main()
{
	# call the implementation of the automation use cases
    test_case_function_run
}
main
