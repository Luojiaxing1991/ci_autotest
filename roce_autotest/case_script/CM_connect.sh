#!/bin/bash

# Establish connection through RDMA CM
# IN :N/A
# OUT:N/A
function CM_connect()
{
	pushd ${ROCE_CASE_DIR}
	./cm-server > ${FUNCNAME}_server.log &
	ssh root@${BACK_IP} " ./${CASEPATH}/cm-client ${FUNCTION}_client.log "
	wait

	scp root@${BACK_IP}:${FUNCTION}_client.log ./

	if [ ` grep -c "pass: 2" ${FUNCNAME}_server.log ` -a ` grep -c "pass: 2" ${FUNCTION}_client.log ` ]
	then
		writePass
	else
		writeFail
	fi
	popd
}

function main()
{
	JIRA_ID="PV-288"
	Designed_Requirement_ID="R.ROCE.F008.A"
	Test_Case_ID="ST-ROCE-43"
	Test_Item="Verify establish connection through RDMA CM"
	Test_Case_Title="使用RDMA CM方式建立连接"
	CM_connect
}

main
