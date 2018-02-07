#!/bin/bash

ROCE_TOP_DIR=$( cd "`dirname $0`" ; pwd )
ROCE_CASE_DIR=${ROCE_TOP_DIR}/case_script

# Load the public configuration library
. ${ROCE_TOP_DIR}/../config/common_config
. ${ROCE_TOP_DIR}/../config/common_lib

# Load module configuration library
. ${ROCE_TOP_DIR}/config/roce_test_config
. ${ROCE_TOP_DIR}/config/roce_test_lib

# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    Module_Name="ROCE"
	local MaxRow=$(sed -n '$=' "${TEST_CASE_DB_FILE}")
	local RowNum=0

	while [ ${RowNum} -lt ${MaxRow} ]
	do
		let RowNum+=1
		local line=$(sed -n "${RowNum}p" "${TEST_CASE_DB_FILE}")

		exec_script=`echo "${line}" | awk -F '\t' '{print $6}'`
		TEST_CASE_FUNCTION_NAME=`echo "${line}" | awk -F '\t' '{print $7}'`
		TEST_CASE_FUNCTION_SWITCH=`echo "${line}" | awk -F '\t' '{print $8}'`

		if [ x"${exec_script}" == x"" ]
		then
			MESSAGE="unimplemented automated test cases."
		else
			if [ ! -f "${ROCE_CASE_DIR}/${exec_script}" ]
			then
				MESSAGE="FILE\tcase_script/${exec_script} execution script does not exist, please check."
			else
				source ${ROCE_CASE_DIR}/${exec_script}
			fi
		fi
		echo -e "${line}${MESSAGE}" >> ${ROCE_TOP_DIR}/${OUTPUT_TEST_DB_FILE}
		MESSAGE=""

	done
}

# Output log file header
writeLogHeader

Init_Net_Ip

TrustRelation ${BACK_IP}

copy_tool_so

main

# clean exit so lava-test can trust the results
exit 0

