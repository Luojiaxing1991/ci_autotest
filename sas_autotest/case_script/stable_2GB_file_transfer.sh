#!/bin/bash

# File transfer stability test
# IN : N/A
# OUT: N/A
function iozne_file_transfer_stability_test()
{
    Test_Case_Title="iozne_file_transfer_stability_test"
    Test_Case_ID="ST.FUNC.049/ST.FUNC.050"

    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            writeFail "Mount "${disk_name}" disk failure."
            return 1
        fi

        ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/iozone -a -n 1g -g 10g -i 0 -i 1 -i 2 -f /mnt/iozone -V 5aa51ff1
        status=$?
        if [ ${status} -ne 0 ]
        then
            umount ${disk_name}
            writeFail "File transfer stability test,IO read and write exception."
            return 1
        fi

        umount ${disk_name}
        rm -f ${ERROR_INFO}
    done

    writePass
}


function main()
{
    JIRA_ID="PV-1612"
    Test_Item="Stable 2GB file transfer"
    Designed_Requirement_ID="R.SAS.N007.A"

    iozne_file_transfer_stability_test
}

main


