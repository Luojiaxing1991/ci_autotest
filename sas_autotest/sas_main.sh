#!/bin/bash


SAS_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load the public configuration library
. ${SAS_TOP_DIR}/../config/common_config
. ${SAS_TOP_DIR}/../config/common_lib

# Load module configuration library
. ${SAS_TOP_DIR}/config/sas_test_config
. ${SAS_TOP_DIR}/config/sas_test_lib

# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    echo "Begin to Run SAS Test!"
    cat ${SAS_TOP_DIR}/${TEST_CASE_DB_FILE} | while read line
    do
        exec_script=`echo "${line}" | awk -F '\t' '{print $6}'`
        TEST_CASE_FUNCTION_NAME=`echo "${line}" | awk -F '\t' '{print $7}'`
        TEST_CASE_FUNCTION_SWITCH=`echo "${line}" | awk -F '\t' '{print $8}'`
        #Get the test title from testcase.table
        TEST_CASE_TITLE=`echo "${line}" | awk -F '\t' '{print $4}'`
        echo "script is "${exec_script}
        echo "CaseInfo "${TEST_CASE_TITLE}" "${exec_script}" "${TEST_CASE_FUNCTION_NAME}" "${TEST_CASE_FUNCTION_SWITCH}

        if [ x"${exec_script}" == x"" ]
        then
            MESSAGE="unimplemented automated test cases."
        else
            if [ ! -f "${SAS_TOP_DIR}/case_script/${exec_script}" ]
            then
                MESSAGE="FILE\tcase_script/${exec_script} execution script does not exist, please check."
            else
		#if [ x"$TEST_CASE_FUNCTION_SWITCH" == x"on" ]
		#then
			echo "Begin to run script: "${exec_script}
                source ${SAS_TOP_DIR}/case_script/${exec_script}
		#else
		#	echo "Skip the Scirpt: "${exec_script}
		#fi
            fi
        fi
        echo -e "${line}\t${MESSAGE}" >> ${SAS_TOP_DIR}/${OUTPUT_TEST_DB_FILE}
        echo ${MESSAGE}
        MESSAGE=""
    done
    echo "Finish to Run SAS Test"
}

#Output log file header
writeLogHeader

# Get all disk partition information
get_all_disk_part

main

# clean exit so lava-test can trust the results
exit 0
