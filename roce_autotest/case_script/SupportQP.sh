#!/bin/bash

#Verify that the maximum number of QP is 256*1024
#IN :N/A
#OUT:N/A
function Up_to_256k_QP()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 13 -e 13 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 13 -e 13 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify Up to 256k QPs fail, please check log!"
	fi

	popd
}

#Verify that the maximum depth of QP's WQE is 16383
#IN	:N/A
#OUT:N/A
function Max_QP_WQE_Depth()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 14 -e 14 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 14 -e 14 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify max QP's WQE depth, please check log!"
	fi

	popd
}

#Verify that the depth of QP's WQE supports 1
#IN :N/A
#OUT:N/A
function QP_WQE_One_Depth()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 27 -e 27 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 27 -e 27 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify QP's WQE depth supports one failed, please check log!"
	fi

	popd
}

function main()
{
    # call the implementation of the automation use cases
	test_case_function_run
}
main

