#!/bin/bash



# disk running business, Reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function fio_single_hard_reset_phy()
{
    Test_Case_Title="fio_single_hard_reset_phy"
    Test_Case_ID="ST.FUNC.110/ST.FUNC.119/ST.FUNC.130/ST.FUNC.141"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &
    change_sas_phy_file 1 "hard_reset"

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count}  ]
    then
        writeFail "disk running business, hard_reset remote phy, the number of disks is missing."
        return 1
    fi
    writePass
}

# disk running business, cycle reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function fio_cycle_hard_reset_phy()
{
    Test_Case_Title="fio_cycle_hard_reset_phy"
    Test_Case_ID="ST.FUNC.111/ST.FUNC.112/ST.FUNC.120/ST.FUNC.121/ST.FUNC131/ST.FUNC.132/ST.FUNC.142/ST.FUNC.143"

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
        writeFail "disk running business, cycle hard_reset remote phy, the number of disks is missing."
        return 1
    fi
    writePass
}

# disk running business, Reset the link_reset file status.
# IN : N/A
# OUT: N/A
function fio_single_link_reset_phy()
{
    Test_Case_Title="fio_single_link_reset_phy"
    Test_Case_ID="ST.FUNC.108/ST.FUNC.117/ST.FUNC.128/ST.FUNC.139"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 1 "link_reset"

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count}  ]
    then
        writeFail "disk running business, link_reset remote phy, the number of disks is missing."
        return 1
    fi

    writePass
}

# disk running business, cycle reset the link_reset file status.
# IN : N/A
# OUT: N/A
function fio_cycle_link_reset_phy()
{
    Test_Case_Title="fio_cycle_link_reset_phy"
    Test_Case_ID="ST.FUNC.109/ST.FUNC.118/ST.FUNC.129/ST.FUNC.140"

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
        writeFail "disk running business, cycle link_reset remote phy, the number of disks is missing."
        return 1
    fi

    writePass
}

function main()
{
    JIRA_ID="PV-1606"
    Test_Item="R.SAS.F008.A"
    Designed_Requirement_ID="Support SAS Narrow and Wide Ports"

    #Get system disk partition information.
    fio_config

    #disk running business, Reset the hard_reset file status.
    fio_single_hard_reset_phy

    #disk running business, cycle reset the hard_reset file status.
    fio_cycle_hard_reset_phy

    #disk running business, Reset the link_reset file status.
    fio_single_link_reset_phy

    #disk running business, cycle reset the link_reset file status.
    fio_cycle_link_reset_phy
}

main


