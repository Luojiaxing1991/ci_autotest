#!/bin/bash

# A CQ binds one QP
#IN :N/A
#OUT:N/A
function One_CQ_One_QP()
{
	Test_Case_ID="ST-ROCE-64"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 11 -e 11 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 11 -e 11 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify a CQ binds one QP successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify a CQ binds one QP failed, please check!!!"
	fi

	popd

	return 0
}

# A CQ binds multiple QPs
#IN :N/A
#OUT:N/A
function One_CQ_Mul_QP()
{
	Test_Case_ID="ST-ROCE-65"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 15 -e 15 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 15 -e 15 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify a CQ binds multiple QPs successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify a CQ binds multiple QPs failed, please check!!!"
	fi

	popd

	return 0
}

#The maximum number of CQ is 64*1024
#IN	:N/A
#OUT:N/A
function Max_CQ_64k()
{
	Test_Case_ID="ST-ROCE-66"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 16 -e 16 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 16 -e 16 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify the max number of CQ successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify the max number of CQ failed, please check!!!"
	fi

	popd

	return 0
}

function main()
{
	JIRA_ID="PV-351"
	Designed_Requirement_ID="R.ROCE.F023.A"
	Test_Item="Support of CQ"
	Test_Case_Title=""

	One_CQ_One_QP

	One_CQ_Mul_QP

	#Max_CQ_64k
}
main
