#!/bin/bash

# Get the SMART information for the SATA disk
# IN : N/A
# OUT: N/A
function smart_disk_check()
{
    Test_Case_Title="smart_disk_check"
    Test_Case_ID="ST.FUNC.195/ST.FUNC.196/ST.FUNC.198/ST.FUNC.199"

    for dev in "${ALL_DISK_PART_NAME[@]}"
    do
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -a ${dev} | grep "${SUPPORT_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && writeFail "${dev} disks do not support smart." && return 1
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -s off ${dev} | grep "${DISABLED_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && writeFail "smart disabled ${dev} failed." && return 1
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -s on ${dev} | grep "${ENABLED_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && writeFail "smart enabled ${dev} failed." && return 1
        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/smartctl -H ${dev} | grep "${STATUS_SMART_KEYWORD}"`
        [ x"${info}" == x"" ] && writeFail "get smart ${dev} status info failed." && return 1
    done

    writePass
}

function main()
{
    JIRA_ID="PV-1608"
    Test_Item="Support SMART"
    Designed_Requirement_ID="R.SAS.F015A"

    # Get the SMART information for the SATA disk
    smart_disk_check
}

main

