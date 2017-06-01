#!/bin/bash



# The driver must support SSP 
# IN : N/A
# OUT: N/A
function driver_supports_ssp()
{
    Test_Case_Title="driver_supports_ssp"
    Test_Case_ID="ST.FUNC.001"

    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ] 
        then
            writeFail "Mount "$disk_name" disk failure."
            return 1
        fi

        time dd if=/dev/zero of=/mnt/test.img bs=4M count=200 conv=fsync 1>/dev/null
        if [ $? -ne 0 ]
        then
            umount $disk_name
            writeFail "dd tools read data error."
            return 1
        fi
    done

    writePass
}

function main()
{
    JIRA_ID="PV-2"
    Test_Item="The driver must support SSP"
    Designed_Requirement_ID="R.SAS.F001.A"
   
    driver_supports_ssp
}

main



