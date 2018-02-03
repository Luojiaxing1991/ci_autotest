#!/bin/bash

# File transfer stability test
# IN : N/A
# OUT: N/A
function iozne_file_transfer_stability_test()
{
    Test_Case_Title="iozne_file_transfer_stability_test"

    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            MESSAGE="FAIL\tMount "${disk_name}" disk failure."
            return 1
        fi

        ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/iozone -a -n 1g -g 10g -i 0 -i 1 -i 2 -f /mnt/iozone -V 5aa51ff1
        status=$?
        if [ ${status} -ne 0 ]
        then
            umount ${disk_name}
            MESSAGE="FAIL\tFile transfer stability test,IO read and write exception."
            return 1
        fi

        umount ${disk_name}
        rm -f ${ERROR_INFO}
    done
    MESSAGE="PASS"
}


function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main
