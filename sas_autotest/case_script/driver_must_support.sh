#!/bin/bash



# The driver must support SSP / The driver must support SMP
# IN : N/A
# OUT: N/A
function driver_supports()
{
    Test_Case_Title="driver_supports"

    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            MESSAGE="FAIL\tMount "${disk_name}" disk failure."
            return 1
        fi

        time dd if=/dev/zero of=/mnt/test.img bs=4M count=200 conv=fsync 1>/dev/null
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            MESSAGE="FAIL\tdd tools read ${disk_name} error."
            return 1
        fi
        umount ${disk_name}
    done

    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main