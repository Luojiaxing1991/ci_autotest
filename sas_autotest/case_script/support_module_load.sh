#!/bin/bash


# module load and uninstall.
# IN : N/A
# OUT: N/A
function module_load_uninstall()
{
    Test_Case_Title="module_load_uninstall"

    local ko_info
    ko_info=`echo ${MODULE_KO_FILE} | sed 's/|/ /g'`
    for ko in ${ko_info}
    do
        insmod ${ko}
        return_num=$?
        info=`lsmod | grep ${ko%.*}`

        if [ ${return_num} -ne 0 -o x"${info}" == x"" ]
        then
            MESSAGE="FAIL\tinsmod load ${ko} fail."
            return 1
        fi
    done

    #Get system disk partition information.
    get_all_disk_part
    [ ${#ALL_DISK_PART_NAME[@]} -eq 0 ] && MESSAGE="FAIL\tload ko file, identify the disk failed" && return 1

    #Mount the disk partition to the local.
    for dev in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${dev}
        return_num=$?
        [ ${return_num} -ne 0 ] && MESSAGE="FAIL\tfailed to mount \"${dev}\"" && return 1
        umount ${dev}
    done

    for ko in ${ko_info}
    do
        rmmod ${ko}
        return_num=$?
        info=`lsmod | grep ${ko%.*}`

        if [ ${return_num} -ne 0 -o x"${info}" == x"" ]
        then
            MESSAGE="FAIL\trmmod uninstall  ${ko} fail."
            return 1
        fi
    done
    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main