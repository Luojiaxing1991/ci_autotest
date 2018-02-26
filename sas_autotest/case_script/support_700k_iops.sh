#!/bin/bash



# the driver should support 700k iops per controller.
# IN : N/A
# OUT: N/A
function fio_iops_controller()
{
    Test_Case_Title="fio_iops_controller"

    sed -i "{s/^iodepth=.*/iodepth=${FIO_IOPS_IODEPTH}/g;}" fio.conf
    info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf | grep "iops="`
    iops=`echo ${info} | awk -F ',' '{print $3}' | awk -F '=' '{print $1}'`

    let iops=iops/1024
    if [ ${iops} -le ${IOPS_THRESHOLD} ]
    then
        MESSAGE="FAIL\tdriver 700k iops verify that ${iops} is lower than ${IOPS_THRESHOLD}."
        return 1
    fi
    MESSAGE="PASS"
}


function main()
{
    #get system disk partition information.
    fio_config

    # call the implementation of the automation use cases
    test_case_function_run

}

main
