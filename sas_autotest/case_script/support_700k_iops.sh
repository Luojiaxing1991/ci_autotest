#!/bin/bash



# the driver should support 700k iops per controller.
# IN : N/A
# OUT: N/A
function fio_iops_controller()
{
    Test_Case_Title="fio_iops_controller"
    Test_Case_ID="ST.FUNC.032"

    sed -i "{s/^iodepth=.*/iodepth=${FIO_IOPS_IODEPTH}/g;}" fio.conf
    info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf | grep "iops="`
    iops=`echo ${info} | awk -F ',' '{print $3}' | awk -F '=' '{print $1}'`

    let iops=iops/1024
    if [ ${iops} -le ${IOPS_THRESHOLD} ]
    then
        writeFail "driver 700k iops verify that ${iops} is lower than ${IOPS_THRESHOLD}."
        return 1
    fi

    writePass
}


function main()
{
    JIRA_ID="PV-1593"
    Test_Item="R.SAS.N001.A"
    Designed_Requirement_ID="support 700kIOPS percontroller"

    #get system disk partition information.
    fio_config

    # the driver should support 700k iops per controller.
    fio_iops_controller
}

main

