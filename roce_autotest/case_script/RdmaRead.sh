#!/bin/bash

#Support of RDMA Read operation.
#IN	:N/A
#OUT:N/A
function RdmaRead()
{
	./${TEST_CASE_PATH}/roce-test -m 2 -s 5 -e 7 -r -f ${TEST_CASE_PATH}/test/test_case_list_server > ${FUNCNAME}_server.log &                                                                                          
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 5 -e 7 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `
	wait 
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 3 -a $ClientFlag == 3 ]
	then
		writePass "Rdma read  success."
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Rdma read fail, please check!!!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-336"
	Designed_Requirement_ID="R.ROCE.F004.A"
	Test_Case_ID="ST-ROCE-50/51/52"
	Test_Item="Support of RDMA Read operation"
	Test_Case_Title=""

	RdmaRead
}

main
