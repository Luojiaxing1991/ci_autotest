#!/bin/bash

# Establish connection through RDMA CM
# IN :N/A
# OUT:N/A
function CM_connect()
{
	pushd ${ROCE_CASE_DIR}
	./cm-server -i $ROCE_PORT > ${FUNCNAME}_server.log &
	Cm_Client_Flag=`ssh root@${BACK_IP} " cd ${CASEPATH}/; ./cm-client -i $ROCE_PORT ${local_port_ip[$ROCE_PORT]} > ../${FUNCTION}_client.log; cd ../; grep -c 'pass: 2' ${FUNCTION}_client.log " `
	wait

	Cm_Server_Flag=`grep -c 'pass: 2' ${FUNCNAME}_server.log`

	if [ ${Cm_Server_Flag} == 1 -a ${Cm_Client_Flag} == 1 ]
	then
		MESSAGE="PASS"
	else
		MESSAGE="FAIL\tVerify establish connection through RDMA CM failed"
	fi
	popd
}

function main()
{
	# call the implementation of the automation use cases
	test_case_function_run
}

main
