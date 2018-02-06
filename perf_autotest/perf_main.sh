#!/bin/bash


PERF_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load the public configuration library
. ${PERF_TOP_DIR}/../config/common_config
. ${PERF_TOP_DIR}/../config/common_lib

# Load module configuration library
. ${PERF_TOP_DIR}/config/perf_test_config
. ${PERF_TOP_DIR}/config/perf_test_lib

# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    cat ${TEST_CASE_DB_FILE} | while read line

    echo "Begin to run PERF test!"

    do
        exec_script=`echo "${line}" | awk -F '\t' '{print $5}'`
        TEST_CASE_FUNCTION_NAME=`echo "${line}" | awk -F '\t' '{print $6}'`
        TEST_CASE_FUNCTION_SWITCH=`echo "${line}" | awk -F '\t' '{print $7}'`
        
        #Get the test title from testcase.table
	TEST_CASE_TITLE=`echo "${line}" | awk -F '\t' '{print $3}'`

        echo "CaseInfo "${TEST_CASE_TITLE}" "${TEST_CASE_FUNCTION_SWITCH}

        if [ x"${exec_script}" == x"" ]
        then
            MESSAGE="unimplemented automated test cases."
        else
            if [ ! -f "${PERF_TOP_DIR}/case_script/${exec_script}" ]
            then
                MESSAGE="FILE\tcase_script/${exec_script} execution script does not exist, please check."
            else
                source ${PERF_TOP_DIR}/case_script/${exec_script}
            fi
        fi
        echo -e "${line}\t${MESSAGE}" >> ${OUTPUT_TEST_DB_FILE}
        MESSAGE=""
    done
}

#Output log file header
writeLogHeader

main

# clean exit so lava-test can trust the results
exit 0

