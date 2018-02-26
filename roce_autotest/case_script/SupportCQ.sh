#!/bin/bash

# A CQ binds one QP
#IN :N/A
#OUT:N/A
function One_CQ_One_QP()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 11 -e 11 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 11 -e 11 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify a CQ binds one QP failed, please check log!"
	fi

	popd
}

# A CQ binds multiple QPs
#IN :N/A
#OUT:N/A
function One_CQ_Mul_QP()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 15 -e 15 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 15 -e 15 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify a CQ binds multiple QPs failed, please check log!"
	fi

	popd
}

#The maximum number of CQ is 64*1024
#IN	:N/A
#OUT:N/A
function Max_CQ_64k()
{
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 16 -e 16 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 16 -e 16 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServrFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		MESSAGE="PASS"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log ${CASEPATH}/log_00*"
	else
		MESSAGE="FAIL\tVerify the max number of CQ failed, please check log!"
	fi

	popd
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}
main
