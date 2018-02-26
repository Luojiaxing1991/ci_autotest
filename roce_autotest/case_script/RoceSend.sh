#!/bin/bash

#Support of Send operation
#IN	:N/A
#OUT:N/A
function RoceSend_MTU()
{
#   lsmod | grep "hi1610_roce_test" > /dev/null
#   if [ $? != 0 ]
#   then
#       insmod ./4120/hi1610_roce_test.ko > /dev/null 2>&1
#       if [ $? != 0 ]
#       then
#           echo "insmod hi1610_roce_test.ko fail, please check it!"
#           return 1;
#       fi
#   fi
#   ssh root@${BACK_IP} " lsmod | grep \"hi1610_roce_test\" > /dev/null; if [  $? != 0     ]; then insmod ./roce/4120/hi1610_roce_test.ko > /dev/null 2>&1; if [ $? != 0 ]; then echo \"Client insmo    d fail\"; return 1; fi; fi; "
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 2 -e 2 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 2 -e 2 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="Fail\tVerify roce send with MTU length failed, please check!"
	fi

	popd
}

function RoceSend_Gt_MTU()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 3 -e 3 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 3 -e 3 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="Fail\tVerify roce send with the length which is greater than MTU and less than 2MTU failed, please check!"
	fi

	popd
}

function RoceSend_Gt_2MTU()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 4 -e 4 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 4 -e 4 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="Fail\tVerify roce send with the length which is greater than 2MTU and less than 3MTU failed, please check!"
	fi

	popd
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}
main
