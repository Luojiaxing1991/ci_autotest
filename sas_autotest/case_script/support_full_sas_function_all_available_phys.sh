#!/bin/bash




# cycle all proximal phy switchec, query whether there is an event.
# IN :N/A
# OUT:N/A
function devmem_switch_all_phy()
{
    Test_Case_Title="devmem_switch_all_phy"
    Test_Case_ID="ST.FUNC.063/ST.FUNC.064/ST.FUNC.100/ST.FUNC101"

    begin_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${LOOP_PHY_COUNT}`
    do
        # clear the contents of the ring buffer.
        time dmesg -c > /dev/null

        phy_ops close all
        sleep 2
        phydown_count=`dmesg | grep 'phydown' | wc -l`
        [ ${phydown_count} -eq 0 ] && writeFail "close all proximal phy, did not produce out event." && return 1

        phy_ops open all
        sleep 2
        phyup_count=`dmesg | grep 'phyup' | wc -l`
        [ ${phyup_count} -eq 0 ] && writeFail "open all proximal phy, did not produce in event." && return 1
    done

    sleep 5
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${begin_count} -ne ${end_count} ]
    then
        writeFail "loop all proximal phy switches, the number of disks is missing."
        return 1
    fi

    writePass
}

# loop hard_reset distal phy.
# IN : N/A
# OUT: N/A
function cycle_hard_reset_phy()
{
    Test_Case_Title="cycle_hard_reset_phy"
    Test_Case_ID="ST.FUNC.092/ST.FUNC.093/ST.FUNC.102/ST.FUNC.103"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${RESET_PHY_COUNT}`
    do
        change_sas_phy_file 1 "hard_reset"
    done
    end_count=`fdisk -l | grep /dev/sd | wc -l`

    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "loop hard_reset distal phy, the number of disks is missing."
        return 1
    fi

    writePass
}

# loop link_reset distal phy.
# IN : N/A
# OUT: N/A
function cycle_link_reset_phy()
{
    Test_Case_Title="cycle_link_reset_phy"
    Test_Case_ID="ST.FUNC.094/ST.FUNC.095/ST.FUNC.104/ST.FUNC.105"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${RESET_PHY_COUNT}`
    do
        change_sas_phy_file 1 "link_reset"
    done
    end_count=`fdisk -l | grep /dev/sd | wc -l`

    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "loop link_reset distal phy, the number of disks is missing."
        return 1
    fi

    writePass
}

# recycle enable distal phy.
# IN : N/A
# OUT: N/A
function cycle_enable_phy()
{
    Test_Case_Title="cycle_link_reset_phy"
    Test_Case_ID="ST.FUNC.0946/ST.FUNC.097/ST.FUNC.098/ST.FUNC.099"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${RESET_PHY_COUNT}`
    do
        change_sas_phy_file 0 "enable"

        change_sas_phy_file 1 "enable"
    done
    end_count=`fdisk -l | grep /dev/sd | wc -l`

    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "recycle enable distal phy, the number of disks is missing."
        return 1
    fi

    writePass
}

# disk running business, switch single proximal phy.
# IN :N/A
# OUT:N/A
function devmen_single_switch_phy()
{
    Test_Case_Title="devmen_single_phy_switch"
    Test_Case_ID="ST.FUNC.106/ST.FUNC.115/ST.FUNC.124/ST.FUNC.135"

    sed -i "{s/^runtime=.*/runtime=${LOOP_PHY_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ judgment_network_env -eq 1 ]
    then
        phy_ops close 0
        sleep 2
        phy_ops open 0
    else
        for i in `seq ${LOOP_PHY_COUNT}`
        do
            phy_ops close 0
            sleep 2
            phy_ops open 0
            sleep 2
        done
    fi

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "disk running business, switch single proximal phy, the number of disks is missing."
        return 1
    fi

    writePass
}

# disk running business, switch multiple proximal phy.
# IN :N/A
# OUT:N/A
function devmem_multiple_switch_phy()
{
    Test_Case_Title="devmem_multiple_phy_switch"
    Test_Case_ID="ST.FUNC.107/ST.FUNC.116/ST.FUNC.125/ST.FUNC.136"

    sed -i "{s/^runtime=.*/runtime=${LOOP_PHY_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ judgment_network_env -eq 1 ]
    then
        phy_ops close 0
        phy_ops close 1
        phy_ops close 2
        sleep 2
        phy_ops open 0
        phy_ops open 1
        phy_ops open 2
    else
        for i in `seq ${LOOP_PHY_COUNT}`
        do
            phy_ops close 0
            phy_ops close 1
            phy_ops close 2
            phy_ops close 3
            phy_ops close 4
            phy_ops close 5
            sleep 2

            phy_ops open 0
            phy_ops open 1
            phy_ops open 2
            phy_ops open 3
            phy_ops open 4
            phy_ops open 5
            sleep 2
        done
    fi

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "disk running business, switch multiple proximal phy, the number of disks is missing."
        return 1
    fi
    writePass
}

# when fio runs the business, polls the swtich proximal phy.
# IN :N/A
# OUT:N/A
function devmem_polling_switch_phy()
{
    Test_Case_Title="devmem_polling_switch_phy"
    Test_Case_ID="ST.FUNC.127/ST.FUNC.138"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${LOOP_PHY_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    for i in `seq ${LOOP_PHY_COUNT}`
    do
        for phy in ${PHY_ADDR_VALUE[@]}
        do
            ${DEVMEM} ${phy} w 0x6
            sleep 2
            ${DEVMEM} ${phy} w 0x7
            sleep 2
        done
    done

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "disk running business, loop switch proximal phy, the number of disks is missing."
        return 1
    fi

    writePass
}


# switch all near-end phys while running the business.
# IN :N/A
# OUT:N/A
function devmem_all_switch_phy()
{
    Test_Case_Title="devmem_all_switch_phy"
    Test_Case_ID="ST.FUNC.126/ST.FUNC.137"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${LOOP_PHY_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    phy_ops clsoe all

    wait
    phy_ops open all
    # wait for all disks to be enabled.
    sleep 60
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "disk running business, loop off all proximal phy, the number of disks is missing."
        return 1
    fi

    writePass
}

function main()
{
    JIRA_ID="PV-1601"
    Test_Item="support full sas function on all available phys"
    Designed_Requirement_ID="R.SAS.F010.A"

    #Get system disk partition information.
    fio_config

    # cycle all proximal phy switchec.
    devmem_switch_all_phy

    #loop hard_reset distal phy.
    cycle_hard_reset_phy

    #loop link_reset distal phy.
    cycle_link_reset_phy

    # recycle enable distal phy.
    cycle_enable_phy

    # disk running business, switch single proximal phy.
    devmen_single_switch_phy

    # disk running business, switch single proximal phy.
    devmem_multiple_switch_phy

    # when fio runs the business, polls the swtich proximal phy.
    [ judgment_network_env -eq 0  ] && devmem_polling_switch_phy

    # switch all near-end phys while running the business.
    [ judgment_network_env -eq 0 ] && devmem_all_switch_phy

    # judge directly connected or connected expander.
    judgment_network_env
    return_num=$?
    if [ ${return_num} -eq 0  ]
    then
        # when fio runs the business, polls the swtich proximal phy.
        devmem_polling_switch_phy

        # switch all near-end phys while running the business.
        devmem_all_switch_phy
    fi
}

main

