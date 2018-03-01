#!/bin/bash



# disk running business, Reset the enable file status.
# IN : N/A
# OUT: N/A
function fio_single_enable()
{
    Test_Case_Title="fio_single_enable"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_ENABLE_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 0 "enable"

    wait
    change_sas_phy_file 1 "enable"
    sleep 60
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count} ]
    then
        MESSAGE="FAIL\tdisk runing business, switch enable disk, the number of disks is missing."
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