#!/bin/bash

#Support of QP
#IN	:N/A
#OUT:N/A
function SupportQP()
{
	./${TEST_CASE_PATH}/roce-test -m 2 -s 14 -e 14 -r -f ${TEST_CASE_PATH}/test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 14 -e 14 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify QP success"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify QP fail, please check!!!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-344"
	Designed_Requirement_ID="R.ROCE.F016.A"
	Test_Case_ID="ST-ROCE-59"
	Test_Item="Support of QP"
	Test_Case_Title=""
	
	SupportQP
}
main

