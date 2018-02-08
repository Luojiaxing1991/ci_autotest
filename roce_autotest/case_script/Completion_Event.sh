#!/bin/bash

#Completion_Event
#IN :N/A
#OUT:N/A
function Completion_Event()
{
	Test_Case_ID="ST-ROCE-82"

	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 26 -e 26 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 26 -e 26 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify Completion_Event successfully"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify Completion_Event failed, please check!!!"
	fi

	popd

	return 0
}

function main()
{
	JIRA_ID="PV-352"
	Designed_Requirement_ID="R.ROCE.F024.A"
	Test_Item="Support of Completion_Event"
	Test_Case_Title=""

	Completion_Event
}
main
