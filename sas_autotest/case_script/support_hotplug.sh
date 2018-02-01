#!/bin/bash



# disk running business, Reset the enable file status.
# IN : N/A
# OUT: N/A
function fio_single_enable()
{
    Test_Case_Title="fio_single_enable"
    Test_Case_ID="ST.FUNC.113/ST.FUNC.114/ST.FUNC.122/ST.FUNC.123/ST.FUNC.133/ST.FUNC.134/ST.FUNC145"

    beg_count=`fdisk -l | grep /dev/sd | wc -l`
    sed -i "{s/^runtime=.*/runtime=${FIO_ENABLE_TIME}/g;}" fio.conf
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 0 "enable"

    wait
    end_count=`fdisk -l | grep /dev/sd | wc -l`
    change_sas_phy_file 1 "enable"
    sleep 60
    if [ ${beg_count} -ne ${end_count} ]
    then
        writeFail "disk runing business, switch enable disk, the number of disks is missing."
        return 1
    fi
    writePass
}


function main()
{
    JIRA_ID="PV-1598"
    Test_Item="R.SAS.F014.A"
    Designed_Requirement_ID="Support hotplug"

    #get system disk partition information.
    fio_config

    # disk running business, Reset the enable file status.
    fio_single_enable
}

main

