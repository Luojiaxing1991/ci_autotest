#!/bin/bash




# cycle all proximal phy switchec, query whether there is an event.
# IN :N/A
# OUT:N/A
function devmem_switch_all_phy()
{
    Test_Case_Title="devmem_switch_all_phy"

    begin_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${LOOP_PHY_COUNT}`
    do
        # clear the contents of the ring buffer.
        time dmesg -c > /dev/null

        phy_ops close all
        sleep 2
        phydown_count=`dmesg | grep 'phydown' | wc -l`
        [ ${phydown_count} -eq 0 ] && MESSAGE="FAIL\tclose all proximal phy, did not produce out event." && return 1

        phy_ops open all
        sleep 2
        phyup_count=`dmesg | grep 'phyup' | wc -l`
        [ ${phyup_count} -eq 0 ] && MESSAGE="FAIL\topen all proximal phy, did not produce in event." && return 1
    done

    sleep 5
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    if [ ${begin_count} -ne ${end_count} ]
    then
        MESSAGE="FAIL\tloop all proximal phy switches, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# loop hard_reset distal phy.
# IN : N/A
# OUT: N/A
function cycle_hard_reset_phy()
{
    Test_Case_Title="cycle_hard_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${RESET_PHY_COUNT}`
    do
        change_sas_phy_file 1 "hard_reset"
    done
    end_count=`fdisk -l | grep /dev/sd | wc -l`

    if [ ${beg_count} -ne ${end_count} ]
    then
        MESSAGE="FAIL\tloop hard_reset distal phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# loop link_reset distal phy.
# IN : N/A
# OUT: N/A
function cycle_link_reset_phy()
{
    Test_Case_Title="cycle_link_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${RESET_PHY_COUNT}`
    do
        change_sas_phy_file 1 "link_reset"
    done
    end_count=`fdisk -l | grep /dev/sd | wc -l`

    if [ ${beg_count} -ne ${end_count} ]
    then
        MESSAGE="FAIL\tloop link_reset distal phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# recycle enable distal phy.
# IN : N/A
# OUT: N/A
function cycle_enable_phy()
{
    Test_Case_Title="cycle_link_reset_phy"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    for i in `seq ${RESET_PHY_COUNT}`
    do
        change_sas_phy_file 0 "enable"

        change_sas_phy_file 1 "enable"
    done
    end_count=`fdisk -l | grep /dev/sd | wc -l`

    if [ ${beg_count} -ne ${end_count} ]
    then
        MESSAGE="FAIL\trecycle enable distal phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# disk running business, switch single proximal phy.
# IN :N/A
# OUT:N/A
function devmem_single_switch_phy()
{
    Test_Case_Title="devmem_single_phy_switch"

    sed -i "{s/^runtime=.*/runtime=${LOOP_PHY_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    judgment_network_env
    if [ $? -eq 1 ]
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
        MESSAGE="FAIL\tdisk running business, switch single proximal phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# disk running business, switch multiple proximal phy.
# IN :N/A
# OUT:N/A
function devmem_multiple_switch_phy()
{
    Test_Case_Title="devmem_multiple_phy_switch"

    sed -i "{s/^runtime=.*/runtime=${LOOP_PHY_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    judgment_network_env
    if [ $? -eq 1 ]
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
        MESSAGE="FAIL\tdisk running business, switch multiple proximal phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}

# when fio runs the business, polls the swtich proximal phy.
# IN :N/A
# OUT:N/A
function devmem_polling_switch_phy()
{
    Test_Case_Title="devmem_polling_switch_phy"

    #Judge the current environment, directly connected environment or expander environment.
    judgment_network_env
    if [ $? -ne 0 ]
    then
        MESSAGE="BLOCK\tthe current environment is direct connection network, do not execute test case."
        echo "the current environment is direct connection network, do not execute test case."
        return 0
    fi

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
        MESSAGE="FAIL\tdisk running business, loop switch proximal phy, the number of disks is missing."
        return 1
    fi
    MESSAGE="PASS"
}


# switch all near-end phys while running the business.
# IN :N/A
# OUT:N/A
function devmem_all_switch_phy()
{
    Test_Case_Title="devmem_all_switch_phy"

    #Judge the current environment, directly connected environment or expander environment.
    judgment_network_env
    if [ $? -ne 0 ]
    then
        MESSAGE="BLOCK\tthe current environment is direct connection network, do not execute test case."
        echo "the current environment is direct connection network, do not execute test case."
        return 0
    fi

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
        MESSAGE="FAIL\tdisk running business, loop off all proximal phy, the number of disks is missing."
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
