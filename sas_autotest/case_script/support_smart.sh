#!/bin/bash

# Get the SMART information for the SATA disk
# IN : N/A
# OUT: N/A
function smart_disk_check()
{
    Test_Case_Title="smart_disk_check"

    for dev in "${ALL_DISK_PART_NAME[@]}"
    do
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -a ${dev} | grep "${SUPPORT_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && MESSAGE="FAIL\t${dev} disks do not support smart." && return 1
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -s off ${dev} | grep "${DISABLED_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && MESSAGE="FAIL\tsmart disabled ${dev} failed." && return 1
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -s on ${dev} | grep "${ENABLED_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && MESSAGE="FAIL\tsmart enabled ${dev} failed." && return 1
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -H ${dev} | grep "${STATUS_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && MESSAGE="FAIL\tget smart ${dev} status info failed." && return 1
    done
    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main
