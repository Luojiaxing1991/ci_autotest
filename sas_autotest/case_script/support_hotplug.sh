#!/bin/bash



# Disk operation, Reset the enable file status.
# IN : N/A
# OUT: N/A
function IO_operation_enable()
{
    Test_Case_Title="IO_operation_enable"
    Test_Case_ID="ST.FUNC.054"

    sed -i "{s/^runtime=.*/runtime=${FIO_ENABLE_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 0 "enable"

    let "FIO_ENABLE_TIME*=2"
    sleep ${FIO_ENABLE_TIME}
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Disk operation, enable failed." && return 1

    change_sas_phy_file 1 "enable"

    writePass
}

function main()
{
    JIRA_ID="PV-1598"
    Test_Item="R.SAS.F014.A"
    Designed_Requirement_ID="Support SAS Narrow and Wide Ports"

    fio_config
    IO_operation_enable
}

main

