#!/bin/bash


XGE_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load common function
. ${XGE_TOP_DIR}/config/xge_test_config
. ${XGE_TOP_DIR}/config/xge_test_lib

# Load the public configuration library
#. ${XGE_TOP_DIR}/../config/common_config
#. ${XGE_TOP_DIR}/../config/common_lib


# Main operation function
# IN : N/A
# OUT: N/A

function main()
{
    cat ${TEST_CASE_DB_FILE} | while read line
    do
        exec_script=`echo "${line}" | awk -F '\t' '{print $5}'`
        TEST_CASE_FUNCTION_NAME=`echo "${line}" | awk -F '\t' '{print $6}'`
        TEST_CASE_FUNCTION_SWITCH=`echo "${line}" | awk -F '\t' '{print $7}'`

        if [ x"${exec_script}" == x"" ]
        then
            MESSAGE="unimplemented automated test cases."
        else
            if [ ! -f "case_script/${exec_script}" ]
            then
                MESSAGE="case_script/${exec_script} execution script does not exist, please check."
            else
                source case_script/${exec_script}
            fi
        fi
        echo -e "${line}\t${MESSAGE}" >> ${OUTPUT_TEST_DB_FILE}
        MESSAGE=""
    done
}

#ifconfig IP
init_net_ip

#set passwd
setTrustRelation

#ifconfig net export
init_net_export

main

# clean exit so lava-test can trust the results
exit 0

