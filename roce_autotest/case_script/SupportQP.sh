#!/bin/bash

#Verify that the maximum number of QP is 256*1024
#IN :N/A
#OUT:N/A
function Up_to_256k_QP()
{
	Test_Case_ID="ST-ROCE-59"
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 13 -e 13 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 13 -e 13 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify Up to 256k QPs success"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify Up to 256k QPs fail, please check!!!"
	fi

	popd

	return 0
}

#Verify that the maximum depth of QP's WQE is 16383
#IN	:N/A
#OUT:N/A
function Max_QP_WQE_Depth()
{
	Test_Case_ID="ST-ROCE-61"
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 14 -e 14 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 14 -e 14 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify max QP's WQE depth success"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify max QP's WQE depth, please check!!!"
	fi

	popd

	return 0
}

#Verify that the depth of QP's WQE supports 1
#IN :N/A
#OUT:N/A
function QP_WQE_One_Depth()
{
	Test_Case_ID="ST-ROCE-63"
	pushd ${ROCE_CASE_DIR}

	./roce-test -m 2 -s 27 -e 27 -r -f test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 27 -e 27 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 1 -a $ClientFlag == 1 ]
	then
		writePass "Verify QP's WQE depth supports one success"
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Verify QP's WQE depth supports one failed, please check!!!"                     
	fi

	popd

	return 0
}

function main()
{
	JIRA_ID="PV-344"
	Designed_Requirement_ID="R.ROCE.F016.A"
	Test_Item="Support of QP"
	Test_Case_Title=""

	#Up_to_256k_QP

	Max_QP_WQE_Depth

	QP_WQE_One_Depth
}
main

