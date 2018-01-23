#!/bin/bash

#Support of CQ
#IN	:N/A
#OUT:N/A
function SupportCQ()
{
	./${TEST_CASE_PATH}/roce-test -m 2 -s 15 -e 16 -r -f ${TEST_CASE_PATH}/test/test_case_list_server > ${FUNCNAME}_server.log &                                                                                       
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 15 -e 16 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 2 -a $ClientFlag == 2 ]
	then
		writePass "Verify CQ success"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify CQ fail, please check!!!"
	fi

	return 0
}
function main()
{
	JIRA_ID="PV-351"
	Designed_Requirement_ID="R.ROCE.F023.A"
	Test_Case_ID="ST-ROCE-64/66"
	Test_Item="Support of CQ"
	Test_Case_Title=""

	SupportCQ
}
main
