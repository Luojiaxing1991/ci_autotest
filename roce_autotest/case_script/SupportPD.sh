#!/bin/bash

#Support of PD
#IN	:N/A
#OUT:N/A
function SupportPD()
{
	./${TEST_CASE_PATH}/roce-test -m 2 -s 11 -e 12 -r -f ${TEST_CASE_PATH}/test/test_case_list_server > ${FUNCNAME}_server.log &                                                                                       
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 11 -e 12 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 2 -a $ClientFlag == 2 ]
	then
		writePass "Verify PD success"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify PD fail, please check!!!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-342"
	Designed_Requirement_ID="R.ROCE.F014.A"
	Test_Case_ID="ST-ROCE-56/57"
	Test_Item="Support of PD"
	Test_Case_Title=""

	SupportPD
}
main

