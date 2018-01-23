#!/bin/bash

#Support of Send operation
#IN	:N/A
#OUT:N/A
function RoceSend()
{
#   lsmod | grep "hi1610_roce_test" > /dev/null
#   if [ $? != 0 ]
#   then
#       insmod ./4120/hi1610_roce_test.ko > /dev/null 2>&1
#       if [ $? != 0 ]
#       then
#           echo "insmod hi1610_roce_test.ko fail, please check it!"
#           return 1;
#       fi                                                                                   
#   fi
#   ssh root@${BACK_IP} " lsmod | grep \"hi1610_roce_test\" > /dev/null; if [  $? != 0     ]; then insmod ./roce/4120/hi1610_roce_test.ko > /dev/null 2>&1; if [ $? != 0 ]; then echo \"Client insmo    d fail\"; return 1; fi; fi; "
	./${TEST_CASE_PATH}/roce-test -m 2 -s 2 -e 4 -r -f ${TEST_CASE_PATH}/test/test_case_list_server > ${FUNCNAME}_server.log &
	ClientFlag=`ssh root@${BACK_IP} "cd ${CASEPATH}/; ./roce-test -m 2 -s 2 -e 4 -r -f test_case_list_client > ../${FUNCNAME}_client.log; cd ../; grep -c \"\-test case success\" ${FUNCNAME}_client.log " `

	wait 
	ServerFlag=`grep -c "\-test case success" ${FUNCNAME}_server.log`

	if [ $ServerFlag == 3 -a $ClientFlag == 3 ]
	then
		writePass "RoceSend success."
		rm ${FUNCNAME}_server.log log_00*
		ssh root@${BACK_IP} "rm ${FUNCNAME}_client.log log_00*"
	else
		writeFail "Roce Send fail, please check!!!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-335"
	Designed_Requirement_ID="R.ROCE.F003.A"
	Test_Case_ID="ST-ROCE-47/48/49"
	Test_Item="Support of Send operation"
	Test_Case_Title=""
	
	RoceSend
}
main
