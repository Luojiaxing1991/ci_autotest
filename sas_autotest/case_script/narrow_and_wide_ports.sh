#!/bin/bash



# disk running business, Reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function fio_single_hard_reset_phy()
{
    Test_Case_Title="fio_single_hard_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &
    change_sas_phy_file 1 "hard_reset"

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count}  ]
    then
        MESSAGE="FAIL\tdisk running business, hard_reset remote phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# disk running business, cycle reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function fio_cycle_hard_reset_phy()
{
    Test_Case_Title="fio_cycle_hard_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    for i in `seq ${FIO_RESET_COUNT}`
    do
        change_sas_phy_file 1 "hard_reset"
        sleep 2
    done

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count}  ]
    then
        MESSAGE="FAIL\tdisk running business, cycle hard_reset remote phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# disk running business, Reset the link_reset file status.
# IN : N/A
# OUT: N/A
function fio_single_link_reset_phy()
{
    Test_Case_Title="fio_single_link_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 1 "link_reset"

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count}  ]
    then
        MESSAGE="FAIL\tdisk running business, link_reset remote phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# disk running business, cycle reset the link_reset file status.
# IN : N/A
# OUT: N/A
function fio_cycle_link_reset_phy()
{
    Test_Case_Title="fio_cycle_link_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    for i in `seq ${FIO_RESET_COUNT}`
    do
        change_sas_phy_file 1 "link_reset"
        sleep 2
    done

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count}  ]
    then
        MESSAGE="FAIL\tdisk running business, cycle link_reset remote phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

function main()
{
    #Get system disk partition information.
    fio_config

    # call the implementation of the automation use cases
    test_case_function_run
}

main
