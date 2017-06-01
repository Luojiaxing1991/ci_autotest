#!/bin/bash



# Disk operation,Turn on and turn off all phy.
# IN :N/A
# OUT:N/A
function polling_switch_phy()
{
    Test_Case_Title="polling_switch_phy"
    Test_Case_ID="ST.FUNC.063/ST.FUNC.064"

    sed -i "{s/^runtime=.*/runtime=$LOOP_PHY_TIME/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &
    
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

    #time=`grep 'runtime' fio.conf | awk -F '=' '{print $2}'`
    #sleep $time
    sleep ${LOOP_PHY_TIME}

    #
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Failed to turn off phy in loop " && return 1

    writePass
}

# Close all phy and open all PHY, use dmesg to query disk log events.
# IN :N/A
# OUT:N/A
function switch_phy_info_query()
{
    Test_Case_Title="switch_phy_info_query"
    Test_Case_ID="ST.FUNC.065"

    flag=0
    init_count=`dmesg | grep "Start/Stop Unit failed" | wc -l`
    #for phy in ${PHY_ADDR_VALUE}
    #do
    #    ${DEVMEM} ${phy} -w 0x6
    #done
    phy_ops close all
    sleep 5
    end_count=`dmesg | grep "Start/Stop Unit failed" | wc -l`

    [ ${init_count} -ne ${end_count} ] && writeFail "Close all phy and use dmesg to query the disk log event failed." && flag=1

    init_count=`dmesg | grep "Write Protect is off" | wc -l`
    #for phy in ${PHY_ADDR_VALUE}
    #do
    #    ${DEVMEM} ${phy} -w 0x7
    #done
    phy_ops open all
    sleep 5
    end_count=`dmesg | grep "Write Protect is off" | wc -l`
 
    [ ${init_count} -ne ${end_count} ] && writeFail "Open all phy and use dmesg to query the disk log event failed." && flag=1

    [ ${flag} -le 0 ] && writePass    
}

# Disk operation, Multiple PHY frequent flash off.
# IN :N/A
# OUT:N/A
function multiple_phy_frequent_off()
{
    Test_Case_Title="multiple_phy_frequent_off"
    Test_Case_ID="ST.FUNC.068/ST.FUNC.069"

    sed -i "{s/^runtime=.*/runtime=$LOOP_PHY_TIME/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &

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

    sleep $LOOP_PHY_TIME
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "multiple PHY frequent flash failure." && return 1

    writePass
}

# Disk operation, close all phy
# IN :N/A
# OUT:N/A
function disk_IO_all_PHYS_off()
{
    Test_Case_Title="disk_IO_all_PHYS_off"
    Test_Case_ID="ST.FUNC.070/ST.FUNC.071"

    sed -i "{s/^runtime=.*/runtime=$LOOP_PHY_TIME/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &

    phy_ops clsoe all
    sleep $LOOP_PHY_TIME

    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Disk operation, closing all PHY failed." && phy_ops open all && return 1

    phy_ops open all
    writePass
}

function main()
{
    JIRA_ID="PV-78"
    Test_Item="support full sas function on all available phys"
    Designed_Requirement_ID="R.SAS.F008.A"

    fio_config
    polling_switch_phy
    switch_phy_info_query
    multiple_phy_frequent_off
    disk_IO_all_PHYS_off
}

main

