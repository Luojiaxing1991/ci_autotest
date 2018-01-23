#!/bin/bash

# case fr m code
# IN :N/A
# OUT:N/A
function codecase()
{
	for index in `seq ${START_INDEX} ${END_INDEX}`
	do 
		./${TEST_CASE_PATH}/server-auto-5-2 ${index} 5 > code_server_${index} &
		ssh root@${BACK_IP} " ./${CASEPATH}/client-auto-5-2 ${index} 5 > code_client_${index} "
		wait

		scp root@${BACK_IP}:code_client_${index} ./
		ssh root@${BACK_IP} " rm code_client_${index} "
		
		local case_id=`expr $index + 1`
		Test_Case_ID="ST-ROCE-${case_id}"
		if [ $index == 0 ]
		then
			JIRA_ID="PV-298"
			Designed_Requirement_ID="R.ROCE.F001.A"
			Test_Item="Support RDMA operations in user space"
		else
			JIRA_ID=""
			Designed_Requirement_ID=""
			Test_Item=""
		fi

		if [ ` grep -c "pass: 1" code_server_${index} ` -a ` grep -c "pass: 1" code_client_${index} ` ]
		then
			writePass
		else
			writeFail
		fi
	done
}

function main()
{
	JIRA_ID=""
	Test_Item=""
	Designed_Requirement_ID=""
	codecase
}

main
