#!/bin/bash



# The driver must support SSP / The driver must support SMP
# IN : N/A
# OUT: N/A
function driver_supports()
{
    Test_Case_Title="driver_supports"
    Test_Case_ID="ST.FUNC.001/ST.FUNC.002/ST.FUNC.003"

    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            writeFail "Mount "${disk_name}" disk failure."
            return 1
        fi

        time dd if=/dev/zero of=/mnt/test.img bs=4M count=200 conv=fsync 1>/dev/null
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            writeFail "dd tools read ${disk_name} error."
            return 1
        fi
        umount ${disk_name}
    done

    writePass
}

function main()
{
    JIRA_ID="PV-1587/PV-1588"
    Test_Item="The driver must support SSP/The driver must support SMP/The driver must support STP"
    Designed_Requirement_ID="R.SAS.F001.A/R.SAS.F002.A/R.SAS.F003.A"

    driver_supports
}

main



