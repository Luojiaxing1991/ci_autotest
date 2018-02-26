#!/bin/bash

# case from code
# IN :N/A
# OUT:N/A
function codecase()
{
	pushd ${ROCE_CASE_DIR}

	./roce-server -n ${CODE_INDEX} -i ${ROCE_PORT} -c 5 > code_server_${CODE_INDEX} &
	Code_Client_Flag=`ssh root@${BACK_IP} " ./${CASEPATH}/roce-client -n ${CODE_INDEX} -i ${ROCE_PORT} -c 5 ${local_port_ip[$ROCE_PORT]} | grep -c 'pass: 1'" `
	wait

	Code_Server_Flag=`grep -c "pass: 1" code_server_${CODE_INDEX}`

	if [ $Code_Server_Flag == 1 -a $Code_Client_Flag == 1 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE="FAIL"
	fi

	popd
}

function main()
{
	CODE_INDEX=`grep -Po "\d*" <<< "${TEST_CASE_FUNCTION_NAME}" `
	TEST_CASE_FUNCTION_NAME=`echo ${TEST_CASE_FUNCTION_NAME:0:8}`
	# call the implementation of the automation use cases
	test_case_function_run
}

main
